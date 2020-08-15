Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5C624520F
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 23:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgHOVkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgHOVkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:40:42 -0400
Received: from mail.pqgruber.com (mail.pqgruber.com [IPv6:2a05:d014:575:f70b:4f2c:8f1d:40c4:b13e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E740BC03D1C5
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 14:00:48 -0700 (PDT)
Received: from workstation.tuxnet (213-47-165-233.cable.dynamic.surfer.at [213.47.165.233])
        by mail.pqgruber.com (Postfix) with ESMTPSA id 565C4C68644;
        Sat, 15 Aug 2020 23:00:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pqgruber.com;
        s=mail; t=1597525247;
        bh=ZYsplzndz3CWTLKIqtnwKDq08lDtU5htBrNPSOFs8g0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=RXEYkX+B5AAg4skO69hd+ibBQdzBQzEYVSqHZCZSWsCWxtAeNhdDggVYObaxmnEcj
         XoVk1RmiFkBG3In/W0ckVuLC/TnQl343Q49MpeJ/vd284sT7BgpUblmwuSLXPIAY27
         WRIZ8DSkJZQqENG1qzrMAd2nwVjlDcgf+MDV3sQk=
Date:   Sat, 15 Aug 2020 23:00:46 +0200
From:   Clemens Gruber <clemens.gruber@pqgruber.com>
To:     netdev@vger.kernel.org
Cc:     Dave Karr <dkarr@vyex.com>
Subject: [RFT] net: fec: Fix MDIO polled IO
Message-ID: <20200815210046.GB37931@workstation.tuxnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <813a0ccb-a309-137d-a340-b9b03b9e230c@vyex.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch fixes the problem on our i.MX6Q boards with Marvell 88E1510
PHYs (1000Base-T).

Tested-by: Clemens Gruber <clemens.gruber@pqgruber.com>

Thanks,
Clemens
