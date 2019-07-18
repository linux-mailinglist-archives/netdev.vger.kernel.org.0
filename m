Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2403A6D6E3
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 00:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfGRWsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 18:48:47 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40047 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbfGRWsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 18:48:47 -0400
Received: by mail-io1-f65.google.com with SMTP id h6so54415828iom.7
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 15:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DX0iaGPswL+M2bDB6JizsGncm//lh+hzMU6+2sUfWPA=;
        b=SJtbba2HwQR2ZJda9OteNiSg6EO0RHIea88XY5G1K1zh4xyCJvu+omC85dNzNRlC53
         6DxVdNyeX0XSmv7F6n97WJEl4uAk/J8KrCJXaFOU7zLvAwlnTAZpVxBTP07MNy6pXWd8
         SmqWoKlyfHbTpoVLiYXlZoDz0tbHeeuPy1Y3VJIV7QDr+5QBs919kZluO3UcT38biSAd
         lltYWPSVs/x+UX372t5+QzFkBopdkrms4onNP3VkTrv41DlPP396g+03T86+qphypjgm
         TkS1tGqN57S74AN0DXB5WGCOzmPAjTb2urtFKPFIjbfwx2Hv7ePfBg+cNq28HJCRTg2m
         VCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DX0iaGPswL+M2bDB6JizsGncm//lh+hzMU6+2sUfWPA=;
        b=OasuWdsIeO9vQd06e9xxxdYYW6uw4sq20tcGgkfEX7XEwZBVyMiNy8HHjrNsAtQHpy
         p+CJlSG2HmTOyt2fr5RydD6QQjWEWAA93Gw7+OjRhyvK6Q2VSBluDsOsvDl/B7SpoWHW
         oxfKmo1XGacVrXln/qaaOUY5dBzFD2laFf2VCrFKezQLOyNrPWPSNu+FK4cMhG3aiYe2
         2bzdsw/vUghRLMa1PvhO0VbN13yuLC0ccXYl3wf0V5KpDKEqPD2U/4q8Un4aD6HKPCCx
         bfkV0g4vEHg1Z+KPuLUvnY5rCcQkOwF063NrBOcrjfy51tnTHmiuyrpYbrGxQ7kh3LWA
         9snQ==
X-Gm-Message-State: APjAAAW21YPtSLEn9St0BfRNUs+BM1nuveSAqp5/4VTIypMLK8Wf3c8Z
        CqKDIf4DsMecNkdhiKBXbys=
X-Google-Smtp-Source: APXvYqzZYNCK16+enKQ+oncv+qIo8yWUwfWZHjK6hAqbB+lyB9iTmHEq/ahy2Uer0MB0whnLRr9CVg==
X-Received: by 2002:a5e:9304:: with SMTP id k4mr47092019iom.206.1563490126563;
        Thu, 18 Jul 2019 15:48:46 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d57e:4df9:f3b0:1b7c? ([2601:282:800:fd80:d57e:4df9:f3b0:1b7c])
        by smtp.googlemail.com with ESMTPSA id i4sm41871465iog.31.2019.07.18.15.48.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 15:48:45 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v5 1/5] etf: Add skip_sock_check
To:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com
References: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <27e1f15f-a609-ab48-75ad-90abb3cfe95e@gmail.com>
Date:   Thu, 18 Jul 2019 16:48:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1563479743-8371-1-git-send-email-vedang.patel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/19 1:55 PM, Vedang Patel wrote:
> ETF Qdisc currently checks for a socket with SO_TXTIME socket option. If
> either is not present, the packet is dropped. In the future commits, we
> want other Qdiscs to add packet with launchtime to the ETF Qdisc. Also,
> there are some packets (e.g. ICMP packets) which may not have a socket
> associated with them.  So, add an option to skip this check.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>  tc/q_etf.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 

applied all to iproute2-next. Thanks


