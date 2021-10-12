Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B4142AF85
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 00:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhJLWLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 18:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhJLWLy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 18:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E79560E09;
        Tue, 12 Oct 2021 22:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634076592;
        bh=Y1NkK8iLTK6kvXxxpMk61cGn0BzlPJPEU6lzn0wGy0c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c01yyjCxhckKy80EzKIWk1UVLYemYLT744KNY0rRG9GsPXo/aZ8Uzz7D2libvN21V
         2HyClMsev9rU31iNQGAPXHRcWRc0q/PVDDFGW1BnjCGFQx6F6RIn/kjXAylLxfM9Cr
         HJbYcicPvZTaMrMOowuINtd3P3tAne6OPK4cj8nadciJA0W3nYqqsghCYxFCrmGFtY
         Z2SbRwM9pw/5OD2UpybqQTVkRFsxdSR/XmlbESV4Z7+3uZ1yB82wtMb7D6tHbn9Idq
         dZ0/qPtlgIERcyAjrSgpZbEPpWOZxBcaylw2wl1RwQsUivl6/7XxJ1fobnrucVbdPI
         oZfAM2yJeEpeA==
Date:   Tue, 12 Oct 2021 15:09:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ralf Baechle <ralf@linux-mips.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Thomas Osterried <thomas@osterried.de>,
        linux-hams@vger.kernel.org
Subject: Re: [PATCH 2/2] ax25: Fix deadlock hang during concurrent read and
 write on socket.
Message-ID: <20211012150951.24a33ce4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4a2f53386509164e60531750a02480a4c032d51a.1634069168.git.ralf@linux-mips.org>
References: <2dea23e9208d008e74faddf92acf4ef557f97a85.1634069168.git.ralf@linux-mips.org>
        <4a2f53386509164e60531750a02480a4c032d51a.1634069168.git.ralf@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 22:05:30 +0200 Ralf Baechle wrote:
> From: Thomas Habets <thomas@habets.se>
>=20
> Before this patch, this hangs, because the read(2) blocks the
> write(2).

Still build issues:

net/ax25/af_ax25.c: In function =E2=80=98ax25_recvmsg=E2=80=99:
net/ax25/af_ax25.c:1685:1: warning: label =E2=80=98out=E2=80=99 defined but=
 not used [-Wunused-label]
 1685 | out:
      | ^~~
net/ax25/af_ax25.c:1685:1: warning: unused label 'out'
