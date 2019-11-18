Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4319A100E9B
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 23:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKRWJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 17:09:38 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45538 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRWJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 17:09:38 -0500
Received: by mail-lf1-f68.google.com with SMTP id v8so15133282lfa.12
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 14:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8A3hWWbRuHoBupfN9n7mLJ1qViF6x/CCXPDjF4jtvpg=;
        b=Npy/DdziNpfVLAJPRdxd7he+xXnAbQBG2x0SaYd/zbtvkBglvTvVIuDq3z1XnXOTaO
         meWP2WveMaapSWS54Xlh5o2T80YRqErgl4FgzYolTywjq9DpULskxrqwZPM4GsohrY3e
         Y93VxH1QJniYqFJSNmQjeANrc+oX9sUgbEnClrZsh9cP9CYJ8tIlM4N7eb5drpoZWknp
         hgqwifUnFqTO2fXBSXDCM5k6xko+vQy3OWbjOnhWciSlOa4J0LpaTw7DLjnJyTvbkn6U
         JngUt/f79kiEFZWxQSz5Y2A8Z2CTTFe1aloFg1dcaKSzG9VEOjQDlTHMD9I3FIBGWsTb
         62Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8A3hWWbRuHoBupfN9n7mLJ1qViF6x/CCXPDjF4jtvpg=;
        b=Ut8AAFTVGQdTgga9q62IujdRAgOjXe13Q9YZBfIv/5zTRhJdSBJyPzpnWltQ06B3SW
         yzDSCRLYZO1v9HBLXUE2xyo53wvaEYIMvkCwADG3dNQ50RhaSql2O7Tp0T6PvpGc1yyH
         NS6gUL253JGIxLyR+xqWkG2yVCKyM9aXzbvNkKOgTsLthfylCJnCQGsC8WvT/6PEYa4Y
         skpODzUOlCwUisZQ0azcN6Unc5QIVD6SApoHt+N+yls03aGvVrFLBiCT57opGaYJtHoN
         ryf+bzjDqGDzewvygmKMa8Wf2MG16v4slAWXOEaopnVh54O29cwT7pNeEvtri4Ll36Fw
         Fs+w==
X-Gm-Message-State: APjAAAXrf58yezlQbqh54IMSBS2Q1alBeJEG+x8Uiaq4Rv93P8StalrI
        sbQe97YQ+vJdZ1QGf2Qzkw24SQ==
X-Google-Smtp-Source: APXvYqyS5wwrYkNk1Nn5q3DbKLw0lCu74eqzYqLo5pKGO8ftlcmnHdiqa2iIVo+jtpjcHaR+eNyxxg==
X-Received: by 2002:ac2:54b1:: with SMTP id w17mr1170777lfk.128.1574114974636;
        Mon, 18 Nov 2019 14:09:34 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm4001963lfy.14.2019.11.18.14.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 14:09:34 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:09:22 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] bnxt_en: Updates.
Message-ID: <20191118140922.61ce49d7@cakuba.netronome.com>
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Nov 2019 03:56:34 -0500, Michael Chan wrote:
> This series has the firmware interface update that changes the aRFS/ntuple
> interface on 57500 chips.  The 2nd patch adds a counter and improves
> the hardware buffer error handling on the 57500 chips.  The rest of the
> series is mainly enhancements on error recovery and firmware reset.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
