Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A64450851
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbhKOPcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:32:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236593AbhKOPcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 10:32:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD52611BF
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636990167;
        bh=WuennYkFVv8PqUTpfTUUidumH+VvT48z0gSct5UtQD8=;
        h=Date:From:To:Subject:From;
        b=ZEN0+VILOtVFpvSoD6BuQnOWbcNutz12gVk5FoWTryR6Qvs3TUvN7i++Fbb/TLa2d
         TzRTTWNuKttVmX2DMi3OOpVcuqAR7pgZt0xxAVM4Tc6YQKH61hf2DJDPFGOilHAEdS
         ttDk6UGJLLaCrpnqcIYF92ZlGVaqX7h92+eaLHunq64gm+DUUsEezryBVPwJOhRnkn
         sK5rUIGkPn2h6vhS2xL5wmtjNK0//Fhkg74k24Qdqxweg/EcvjDiFvWmqj8xoFVFWL
         Lhvg3DEgqGsTibUVitbZ3mNJH75RF7Ue6izy82Kjkte8xxslYczqcrGOzpI/6pk2cF
         SX1dVI4IQD/EQ==
Date:   Mon, 15 Nov 2021 07:29:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: net-next is OPEN
Message-ID: <20211115072926.020a7eee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just to make sure y'all know this - net-next is taking patches.
