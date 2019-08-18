Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A909190E
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 20:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfHRSvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 14:51:05 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42632 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRSvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 14:51:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id i30so5797332pfk.9
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 11:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AvLwTAx/v5Q4Xe4/bOCtfztSXzliuHriOltkezvl6tg=;
        b=VVny0G2U8C3ibyw+tX4ydASsQ8RVa1LWkLMsdanRMhMZZ4cpwZ7lzspSjs6VEDm5q+
         fP1Eh2Y5y1TcbDVI6wxEG4+rYNR7HXACBOuAITx1rXHqNyRIXAIRwiU+IC/ViRTityM0
         1pn50k3N3unPnHEQIB+ywXnso//Tmewm8e3ks1q6jnLIg3bWiR8LGUpzY20+nUCk/JGp
         HFwGl3rEwbJ0xMrtekkN1XcElSvM7NNATMEBJ58k/IjEYwfsJkkpdIy/Tv0mjrwyrG/j
         aLEKp2s9T8cgN/uKmKI6Bru5jIEuLWNOhKe/lTokSAPbQ8iZTGTOrS4DWeFT4KwTQJDJ
         5Ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AvLwTAx/v5Q4Xe4/bOCtfztSXzliuHriOltkezvl6tg=;
        b=lly+tedaB50k+1FtNezz+aQhIhWI97PsYKS9EWdcqkYgN1yN9s+ZwEW+pl2ut6lVX5
         G8eX7wCR+j6PV/YCdQifnUKsm5gtwo0IGA/lRuFMQhFH8+fG7nd1d99plmKwcQS77CXR
         s7F0rCMPXuEXx9lQe/0kwcDbARAF/JUQHWsLYxl+30+72NXCI4I/4nF1B2ZefRFwfMWC
         w2jYAmmt3m9HWO5wfPI/hnAItZyVknAPfSfceQJVkxmHbwoz95mM2+iaJLV67ptkeSlV
         4HxoYiHg8Y+ry+euIvt8UGGqKZLnB5tLR11TiMLrIp5kbZZrvULb3MCfQ/JFzz04JG+K
         8vUg==
X-Gm-Message-State: APjAAAW1NPttGZCKDeLKnBA3KlaNOSTBSvwBRGdEBnG3hlTO27J4Kw+g
        7j5BDGW44mRcQysEGsewK8dqD3wOkCc=
X-Google-Smtp-Source: APXvYqyV+kp5xF6fNz/d5PCzAY4KUODoJi397uWVZaA+1K/ozCtuSUsimusiLRToVkdmk9ssbfexLw==
X-Received: by 2002:a65:4205:: with SMTP id c5mr16479089pgq.265.1566154264539;
        Sun, 18 Aug 2019 11:51:04 -0700 (PDT)
Received: from [172.27.227.166] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id x2sm12502047pja.22.2019.08.18.11.51.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 11:51:03 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 0/4] Add devlink-trap support
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20190813083143.13509-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <188365cc-532b-eb5b-7236-320bdc0c277e@gmail.com>
Date:   Sun, 18 Aug 2019 12:51:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190813083143.13509-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 2:31 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patchset adds devlink-trap support in iproute2.
> 
> Patch #1 increases the number of options devlink can handle.
> 
> Patches #2-#3 gradually add support for all devlink-trap commands.
> 
> Patch #4 adds a man page for devlink-trap.
> 
> See individual commit messages for example usage and output.
> 
> Changes in v2:
> * Remove report option and monitor command since monitoring is done
>   using drop monitor
> 
> Ido Schimmel (4):
>   devlink: Increase number of supported options
>   devlink: Add devlink trap set and show commands
>   devlink: Add devlink trap group set and show commands
>   devlink: Add man page for devlink-trap
> 
>  devlink/devlink.c          | 448 +++++++++++++++++++++++++++++++++++--
>  man/man8/devlink-monitor.8 |   3 +-
>  man/man8/devlink-trap.8    | 138 ++++++++++++
>  man/man8/devlink.8         |  11 +-
>  4 files changed, 581 insertions(+), 19 deletions(-)
>  create mode 100644 man/man8/devlink-trap.8
> 

applied to iproute2-next. Thanks

