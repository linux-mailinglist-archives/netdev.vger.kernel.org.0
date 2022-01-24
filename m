Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514CB4983BF
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbiAXPpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:45:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35702 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbiAXPpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 10:45:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5B656145C
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 15:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F994C340E1
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 15:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643039110;
        bh=+cJkBl6hy/ujG8Bqa6lGHuAWGjsxx0fuI6l2E5fuzoI=;
        h=Date:From:To:Subject:From;
        b=O/ABMwfnbPeVNA4mm3neT4fiFo8giTRvXuoIKTbkQI6ez1uLJDTFxAxDrvBxOKcGm
         UwfKBelnqI89nr4kwopLjy9/o4o4Nj20X6POBaZPwrROWkbKiTnFF5q5Fy6i4//mZs
         amCm3wONW+2zVQT+OckIM3ShkxvvUx3MXp2slxPktYcVoLb3aoshooU1sdTuvDwWE8
         vK4wrLlbH57KpPxFQf7bGc1ldNQbsj9RynR7S7HsgPkHRyM6yLqC5SasxisT+JXPP9
         nkC093t+QJBun4CzJFd/Vx1dJod8Ocz4XS9ikbWoTxagPq/WrIrvkrPSWhvoxKLAJj
         aTxubq+YJTBcg==
Date:   Mon, 24 Jan 2022 07:45:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: net-next is open
Message-ID: <20220124074508.0cee250d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net-next is open and accepting patches.
