Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E27C308D2D
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhA2TMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232773AbhA2TL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 14:11:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 089BC64DFB
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611947478;
        bh=7YlGELKbxW25E29uG2dXaqam6k9KiHV0/qWhw3a73W8=;
        h=Date:From:To:Subject:From;
        b=k5o4RUNX8PWTKlbK0nr6VaEAqX/wNwtOgeUDg5S+Bn5FJN3ixs7xLYfFGXtaPOxSb
         IAX5gLsrI79diAwpkO9TdF74YEU4hLdkE1C+a5Zkm49oAhjVJuUSeaVRiDTFIaP0Gb
         +5wXx8A+k5PfJwUzLZNTZXsDXFsBOTSJfvkrI2o4uhQzuZikvCuAnrQVRJAbt3yi2v
         f5TM5GZShfSkRYcGrhLWxzsqZnNxns2hn0bJsgPVe1mCeCVyWilQTIZUpdis3KUGij
         JZd5fiI+NQNI+l5yKb7fK7JOqJ1i3iXDYlZBESBTdGw2YZDlRxoJBmGh2bUEJQWqXG
         VnVTWHzrRxxZw==
Date:   Fri, 29 Jan 2021 11:11:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Another snag
Message-ID: <20210129111116.618a7649@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

FYI vger hit a disk problem around midnight pacific time. It was fixed 
a few hours ago but comparing my inbox to lore I think a few emails
sent during the night went into the void.

Stuff may still filter through, but if in doubt please double check
patchwork and resend as needed.
