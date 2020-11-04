Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A512A5FD8
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 09:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKDIrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 03:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgKDIrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 03:47:15 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB408C0613D3;
        Wed,  4 Nov 2020 00:47:13 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id cw8so15047685ejb.8;
        Wed, 04 Nov 2020 00:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9TTQk/pFwT0hsLj1WUHd7Qq3TkVzI1fcQ441lqWMnwo=;
        b=s7zvVGaGV1WIGDtEpP1Ux6Y8ztj24SfbhVsgOUIvsk9SdQAVYg52ho02YINRBcBKz8
         tr+TPNvJXORGSLQN2o96qIg2Toa4OTgxCpH0wtMgVEfO6P9njSPcbaSS3bcNFzX5lIQr
         1SrZ6SyXTn3wCjMZKTT9/3Of+ZuXQDNZ0eF7RDf7mM2+x+AqNT9hR+lJVwb+HpEHyXDH
         eQYhXE12PdoHIvNu3PuiNLQcgOo9XzcMyX/htKEdBsfZNx5lT8T88kmZ/+ZFBtB9yJxd
         SYMSBBatkm6Kl3SxMG2BQ02WFGk5QejXZoOKH0n4QBUMGNaq6PrdDJgODtJLvN8EYhOi
         FXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9TTQk/pFwT0hsLj1WUHd7Qq3TkVzI1fcQ441lqWMnwo=;
        b=JYJm39Sf5EaamdZYxvwJtZga5QhOEBmUXzFdjaj/5fLm6PPZN5kgXeektnCSqKC+Au
         Ybzf8xCZd1vg8Vx7sPnSktR/KMBGXLdmekSyeYsU3cfkA9/tR3pDIOQ/khmpqeReW6gA
         /intj8ZiQ2uibw7YOcJXrckIqjCElT1TXaSwOMTIiHlvDJX2L/o9VbT8cVvhBzDGve2i
         WLBeJOfaJr+vv/gnPLZZalp7oTTsmiv71dio+8q3+FwD4264Dybc5idyAhviOGAnu2Bo
         OH30inD8+EzAi3vLPBGHGYaCHsopdIlvgjrRXfBMxiqHb2JG1BffyoibVSuH/Tcq2GEE
         atVg==
X-Gm-Message-State: AOAM531YsY4L5W1KbavFcOxHb+aQ4hlu01aogoLT87W9GLfWh8LsEC4k
        wX4Hg6AMwOLhpwOIv443s56N22nRlFY=
X-Google-Smtp-Source: ABdhPJy3GViHmRCg7B5RKytadHwqCf3kyfABask6kNqjCVPiL9WBTUUGHizY/Wj+gP6MBKSH5VEyQQ==
X-Received: by 2002:a17:906:1390:: with SMTP id f16mr1918310ejc.504.1604479632572;
        Wed, 04 Nov 2020 00:47:12 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id v21sm660966edt.80.2020.11.04.00.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 00:47:11 -0800 (PST)
Date:   Wed, 4 Nov 2020 10:47:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201104084710.wr3eq4orjspwqvss@skbuf>
References: <20201103192226.2455-1-kabel@kernel.org>
 <20201103192226.2455-4-kabel@kernel.org>
 <20201103214712.dzwpkj6d5val6536@skbuf>
 <20201104065524.36a85743@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104065524.36a85743@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 06:55:24AM +0100, Marek Behún wrote:
> On Tue, 3 Nov 2020 23:47:12 +0200
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > On Tue, Nov 03, 2020 at 08:22:24PM +0100, Marek Behún wrote:
> > > Add pla_ and usb_ prefixed versions of ocp_read_* and ocp_write_*
> > > functions. This saves us from always writing MCU_TYPE_PLA/MCU_TYPE_USB
> > > as parameter.
> > > 
> > > Signed-off-by: Marek Behún <kabel@kernel.org>
> > > ---  
> > 
> > You just made it harder for everyone to follow the code through pattern
> > matching. Token concatenation should be banned from the C preprocessor.
> 
> So you aren't complaining about the definition of pla_ and usb_
> functions, just that they are defined via macros?

Yes.
