Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A48223002
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgGQAhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgGQAhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 20:37:01 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDE3C061755;
        Thu, 16 Jul 2020 17:37:01 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m9so4532270pfh.0;
        Thu, 16 Jul 2020 17:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Ia9lwKuYWAs1dXC9cpUp3o/54vZA86HM0tRpPSoBhY=;
        b=LS08LWzi1o9aP3ElA3bElXvlu6NsaQNQiRrry1+NmX+UHL8jAs7SrOpgseVgcnzJwk
         jDcxNJ19YgCcY68z3UaxFNndW3E/MMfUzvlVY3aW5JAkwyVzQaflllfKmNzE0kcUqJQh
         tkf4KgHUzyjmI91XFfPFDaxizrGxUNar//Z+5CDX7TOM5cYi2lhCXa2vB1iML36metOE
         fqYgADUckitKvVLU8Ngh8yH7Tn2EECGzAspqslLvAAMxBjRgfGEYVgIkOQ/4MKNGCrq2
         GekNa9n1+SlXb3Pn682nItnByeXymFvOa1L9ESHdRww7hyI8C47CbzNwsEgZ5FdKtHHn
         kXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Ia9lwKuYWAs1dXC9cpUp3o/54vZA86HM0tRpPSoBhY=;
        b=dJm/+KQ+FzHrGpJHD0jgstU1e2o136bKQjKKcmceoBHqeTSgV3S7Ta0Ou25RTnjnG5
         uvhTDwu0zAWb7HoRU4K635faNIYcXvdulkq9WbbSjmOET1ez/vuZcAKTsO0/MLVrWd7g
         AmBp8B3GiwiKG8iaaGW+iSkCrP13YlwSPT0WAh7zn4eL0aozKx3JrCInZJerEfMhO9/9
         f8zhWA5NB7doJKVgaWzJuVU3nH6Y9/7XVp9bD87tmgafVSHBBEUv/7bfnbtVDCWpthlG
         YnxKMt4LwL4V2iyC9SebVPgBerJqjRePUQ1BMJRoPSyDd+F1siHl8pbhtq86s+iBd0fI
         QaZg==
X-Gm-Message-State: AOAM533FoakqduZbIyCJsA34O3ILSUzJHjoSVqnlPdYUb7s93/FBUxxi
        xOCimQZsnPS7n7C496DJJJjtJSdw
X-Google-Smtp-Source: ABdhPJzQ34WuLQgSuWRBH1xmAZO58VueCwA8XX9CHu0N86n7Hhl3X+y+k8fjqaQNlIaLFfspVAESBg==
X-Received: by 2002:a63:541e:: with SMTP id i30mr6609471pgb.47.1594946220681;
        Thu, 16 Jul 2020 17:37:00 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id v11sm6291954pfc.108.2020.07.16.17.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 17:36:59 -0700 (PDT)
Subject: Re: [PATCH net 1/3] net: bcmgenet: test MPD_EN when resuming
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
 <1594942697-37954-2-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d445afad-7c73-7552-7347-63fc3b984483@gmail.com>
Date:   Thu, 16 Jul 2020 17:36:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594942697-37954-2-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2020 4:38 PM, Doug Berger wrote:
> When the GENET driver resumes from deep sleep the UMAC_CMD
> register may not be accessible and therefore should not be
> accessed from bcmgenet_wol_power_up_cfg() if the GENET has
> been reset.
> 
> This commit adds a check of the MPD_EN flag when Wake on
> Magic Packet is enabled. A clear flag indicates that the
> GENET hardware must have been reset so the remainder of the
> hardware programming is bypassed.
> 
> Fixes: 1a1d5106c1e3 ("net: bcmgenet: move clk_wol management to bcmgenet_wol")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
