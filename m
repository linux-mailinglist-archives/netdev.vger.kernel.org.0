Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717F420EBE4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgF3DQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgF3DQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:16:56 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C06C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 20:16:56 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d18so9148815edv.6
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 20:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HIhXs0z2Yz9q8SXuvfQIG3USXq8HsaDkLvr70l/G3I4=;
        b=gPuLGz37hfJGF5lG51PxLb/0hDtGcGIzZLhHUx6r9O8yHqS8YPtLrPTjyTRvjJ2L7F
         bvSbLRvQsBANWPSwNH3cmbW7JemXPkY6X2OK0gIYvM/KFT84DFCg+VbO/opUpY61HJSf
         eRF/v5OvWD8TFl/dZiLXYq7gMt9U93eXxPDEh7EFAGQz3IucishFDRILbVyJH60RBwJt
         7oCD/h3qhcnRAtitn66RptmizT3OTYwOuOIXilrb+Zse20Saq8LNovBSwltx7FbPshnR
         Wl/XT6riU1/gGmrepnPHfIijn5ppmJ5xLGz6cv95m8z31jDjqiFcjJEaBsRCJbf1q5M+
         +SGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HIhXs0z2Yz9q8SXuvfQIG3USXq8HsaDkLvr70l/G3I4=;
        b=Jny5VTnRkhcMPUx2URNGPOIhETV7wpMYSCgcoAkr37M4OnnjbC/vSEKj9ynYSLecSt
         THouPWCoDfre2h5zvp082tD3SdbqwP+f2W96A4oje3NnaPUOMPsSn46qu1r/Vnac5rCz
         hhZWQq6Qb8Dt/i6u31aIK3Vz0jEWffzKg6liIuJ6VgWrXnMfOEiJ/9ScCOIbr+M7fkBa
         hvUs2+a9i5A9waHGkkSBnhEzFq+87qj6Dg4E7bkj4zif7ZQqjFq0kMpIpbQg4UxKkQjy
         pBIUGrc7tWi4+wvTZGHDuBouCDWK1D8kUsfizfsvaZ+DcUFkgf6GsWCxV4AGSiMXrvQG
         Lz2w==
X-Gm-Message-State: AOAM533MICRJcU9lRTBdnnSkW6PsO502DjPnikShDp4T+W0pWS0xTEpH
        P+9j+PG+ckxG7dauyNrIV+o=
X-Google-Smtp-Source: ABdhPJzmw3UJJaDnVUQ255d9jfCP95a5ljXul+wz48Ml4p5YSJEGfGNEh9rk20sXI5269/gfkjFu+g==
X-Received: by 2002:aa7:db57:: with SMTP id n23mr20507094edt.235.1593487014882;
        Mon, 29 Jun 2020 20:16:54 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m6sm914520ejq.85.2020.06.29.20.16.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 20:16:54 -0700 (PDT)
Subject: Re: [PATCH net-next 0/8] Add PAL support to smsc95xx
To:     Andrew Lunn <andrew@lunn.ch>, Andre.Edich@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
References: <c8fafa3198fcb0ba74d2190728075f108cfc5aa1.camel@microchip.com>
 <20200630013356.GG597495@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fee052b8-dadb-5a63-7b97-8d2da00ab798@gmail.com>
Date:   Mon, 29 Jun 2020 20:16:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200630013356.GG597495@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/2020 6:33 PM, Andrew Lunn wrote:
> On Mon, Jun 29, 2020 at 07:55:24PM +0000, Andre.Edich@microchip.com wrote:
>> To allow to probe external phy drivers, this patchset adds use of
>> Phy Abstraction Layer to smsc95xx driver.
> 
> This is version 2 correct? Please put v2 in the Subject line.
> 
> Also, list here, what has changed since v1.

Andre, when  you resubmit, please also configure your email client or
git send-email/format-patch such that every patch is in reply to the
cover letter, this makes it a lot easier with email threading for
reviewing your changes. Thank you.
-- 
Florian
