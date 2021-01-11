Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AEF2F1BB3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbhAKRCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbhAKRCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:02:42 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8767C061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:02:01 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id w1so579420ejf.11
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k1r1/u1U9Rmoi5oDl+OcwW5HT+cIx8XkoNqiDQdyVX8=;
        b=KKHLJDWgMIxRbTUvyruCgQWrZgpLHJl+DTa2T5f3LwhFEEVhQ2lShYMVReP9xjkD2o
         NMtkVgBMYGqmQgQDmNvVEiQuvOHSCO8lRhpVtYObVKCOrnixzazwA+QOeFsADug+YvjW
         S48HNotZru4KpzbK0vDOuKLjm2DUobf41YJzK68eaB6ypi+1iqvaOgRG2XLApN2p8cmQ
         sTujCkgWuuVwOTvQ8FjMRx8pcAlbSYHOL7ArAR7cnDzlq9NhYKc9G+jzuu/4JsvqKAx4
         VQXsdUKcybq386Pj2HO2wsu3WhsgilWh4GbiS9CBIkpjERGqiPvryc0npGUFZ7aOgZHJ
         FGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k1r1/u1U9Rmoi5oDl+OcwW5HT+cIx8XkoNqiDQdyVX8=;
        b=qOOKiNNr0FcKX4cyU4Pq6/AKxsfDAmWopivM55/CToLhWGwGaG8TKRdbajGHu8z2Sg
         lBl9At1tsGne2WEw1650kA3yLsUaFY4KbzZEcSdHGhAJ4I/UHVaLuCkP7+Al+/r3ha1A
         gJKfaKFziaWedPyE9o9WAahp2xutbtR5bJdjWw7vzfA9WokLGztCS7X+owvptH6h4hWJ
         u/FirgarajqcwIzpu9Lna2L3GtMvMk3s3aQ38dIQFk10a5qmdQQ8VoMQ35D5PalDn9uB
         VJ2Sxhych4fELxPIvFOBbCMAR/FZAU01fPxgvhkYhXLyD81wods2U0GtPVMrvROlyv3x
         uMkg==
X-Gm-Message-State: AOAM533My+dSZX9grtpLCugitE0lsnZO+15XKz8O6wVLmLsSq8wV7dou
        VIC3i1GFLKdknulVOV4PYVk=
X-Google-Smtp-Source: ABdhPJyTrEIJ19O9bnr5eGq+FgodoJVovLKnxeEatWjmVOTpOW9axhv+/2elvi34dUehvADwr+rj5Q==
X-Received: by 2002:a17:906:565a:: with SMTP id v26mr305091ejr.332.1610384520564;
        Mon, 11 Jan 2021 09:02:00 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x4sm200201edr.40.2021.01.11.09.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:01:59 -0800 (PST)
Date:   Mon, 11 Jan 2021 19:01:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 04/10] net: dsa: felix: reindent struct
 dsa_switch_ops
Message-ID: <20210111170158.x65oarb4ilw7ytcp@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-5-olteanv@gmail.com>
 <20210109172419.63dcaea9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109172419.63dcaea9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 05:24:19PM -0800, Jakub Kicinski wrote:
> On Fri,  8 Jan 2021 19:59:44 +0200 Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The devlink function pointer names are super long, and they would break
> > the alignment. So reindent the existing ops now by adding one tab.
>
> Therefore it'd be tempting to prefix them with dl_ rather than full
> devlink_

Indentation is broken even with devlink_sb_occ_tc_port_bind_get reduced
to dl_sb_occ_tc_port_bind_get.
