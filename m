Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAA4CFE4F
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfJHQAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:00:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34096 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfJHQAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:00:41 -0400
Received: by mail-pl1-f193.google.com with SMTP id k7so8652861pll.1;
        Tue, 08 Oct 2019 09:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wjbVP6SypA/yqxO11UpZl9j4IvRacVDxxX21VBwViOY=;
        b=QCRICrIihtFumFoyDtKyU2p+eUACHmtbZBnIV0I8OuOXiYPKh2f5BKz8oUUaXc3lvT
         7LAq+EF9Fgn2LluD0gVmI534y4qpfDwOTaici1bPDAHhcFWqopXA409BSgIWJZcD/SDw
         lPq3t7Qagr/CSAOx+VNnFuqDQ3iRUW2jC0/8GqvYkJRH49X+nF4LVgPgt53eoAwZW3OU
         FQx2oeOWRBEY9LtdVjld21f0OccvhTzw1QxwYy7okCmg+c0QJb1/JU6D8S/wYv3wIOrj
         6qLHELPGnSIcVnTP7jZ429gFuU945Tf5Ce4RL/f6z8JQWACBjcVBQT0YncITmG//Xk4h
         mlsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wjbVP6SypA/yqxO11UpZl9j4IvRacVDxxX21VBwViOY=;
        b=nt9z+2oFUPdZWwh40bDWyMoNsD1lPZpG1uSfSzJ0pIdCHt+RiNNDce2GS0VkjRWJFZ
         M9LQR81Ob8CUo6wp3YzuFqfSAowJF2lxhicIUUO+zZfaee/yG36atQQrM1NH33BSfzWj
         krx0v0e4nhiMNcv2xa28cws0gJLQozSL8Uv4XXLHwQ3/Ex4nVivQWM816CEI9cHK8SyX
         CsOFhQ1zAtxk/hbzUsk3YyOf7HIjw3xx5ZfrzDrIKfTael1NnBFi6LwvzQalvwrtZABA
         cQBrx7AVfFFzixeo7xtH4S9u1w38KPXi97ULfxY5v/1LfIwqf5p2KLm7vx8rR6jhcD1J
         18pA==
X-Gm-Message-State: APjAAAVTAaOlQpFqQO5V0PupOKqBSHdliteEziRpyH+C77a3leiGmeKg
        OT291bR8C2i02dbuVStZ3wo=
X-Google-Smtp-Source: APXvYqxTubSCND8Zeg5GzoPb4dZLEhBcUxVuv81AxxZDH2iL+IHH8/l2M59SrZ23dDtZksHH6C+Zuw==
X-Received: by 2002:a17:902:b583:: with SMTP id a3mr36650807pls.169.1570550439806;
        Tue, 08 Oct 2019 09:00:39 -0700 (PDT)
Received: from ?IPv6:2620:10d:c082:1055::2a69? ([2620:10d:c090:200::3:df92])
        by smtp.gmail.com with ESMTPSA id c128sm19211093pfc.166.2019.10.08.09.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:00:38 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH v3] rtl8xxxu: add bluetooth co-existence support for
 single antenna
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
References: <20191005094826.90814-1-chiu@endlessm.com>
Message-ID: <4603f17b-6739-1168-f784-58b0b9cf1a74@gmail.com>
Date:   Tue, 8 Oct 2019 12:00:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191005094826.90814-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/19 5:48 AM, Chris Chiu wrote:
> The RTL8723BU suffers the wifi disconnection problem while bluetooth
> device connected. While wifi is doing tx/rx, the bluetooth will scan
> without results. This is due to the wifi and bluetooth share the same
> single antenna for RF communication and they need to have a mechanism
> to collaborate.
> 
> BT information is provided via the packet sent from co-processor to
> host (C2H). It contains the status of BT but the rtl8723bu_handle_c2h
> dose not really handle it. And there's no bluetooth coexistence
> mechanism to deal with it.
> 
> This commit adds a workqueue to set the tdma configurations and
> coefficient table per the parsed bluetooth link status and given
> wifi connection state. The tdma/coef table comes from the vendor
> driver code of the RTL8192EU and RTL8723BU. However, this commit is
> only for single antenna scenario which RTL8192EU is default dual
> antenna. The rtl8xxxu_parse_rxdesc24 which invokes the handle_c2h
> is only for 8723b and 8192e so the mechanism is expected to work
> on both chips with single antenna. Note RTL8192EU dual antenna is
> not supported.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> ---
> 
> Notes:
>    v2:
>     - Add helper functions to replace bunch of tdma settings
>     - Reformat some lines to meet kernel coding style
>    v3:
>     - Add comment for rtl8723bu_set_coex_with_type()

Looks good to me!

Signed-off-by: Jes Sorensen <Jes.Sorensen@gmail.com>

Jes

