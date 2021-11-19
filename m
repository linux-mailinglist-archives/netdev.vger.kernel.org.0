Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76795456A44
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhKSGfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSGfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 01:35:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FDC561154;
        Fri, 19 Nov 2021 06:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637303549;
        bh=OHkAYsvD0uKPKb8nG+HuJxykyXW7Ftf3m1+RoFYWSW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=deOy+AnUvi+g1408Su7D3Z8MNREHZaOt8joLNAtV22FgtduKQEf7T6GvU8fiQqekE
         NUY1T/IeO+JYqKpWjx+tWfCYPxkL9IJ0yaTi9wTO2ZLEseTx3tD4V+PipYzhUiYOXN
         BAbGTnNURMDwcCRJprTWAOqlvZrEKnkGQY9K7hhCLggGOXeNjpl8i3aNmbXZdQqsE6
         OidbUst6fx4OCfB8cZYebpun+PVsGm21hijVN0GKLB7215lizhtXZ/2Gt82uiK8oLw
         FFdgGXvz3s9KPwOQ8//L6/BYj+uXNgvWjUOzUnuhGzv9/JVX+zB4DasVOLMVH2JdzW
         p8ng3bwVYIJ2w==
Date:   Thu, 18 Nov 2021 22:32:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kumar Thangavel <kumarthangavel.hcl@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>, openbmc@lists.ozlabs.org,
        linux-aspeed@lists.ozlabs.org, netdev@vger.kernel.org,
        patrickw3@fb.com, Amithash Prasad <amithash@fb.com>,
        sdasari@fb.com, velumanit@hcl.com
Subject: Re: [PATCH v7] Add payload to be 32-bit aligned to fix dropped
 packets
Message-ID: <20211118223228.7edfeade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211118160301.GA19542@gmail.com>
References: <20211118160301.GA19542@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 21:33:02 +0530 Kumar Thangavel wrote:
> +const static int padding_bytes =3D 26;

/net/ncsi/ncsi-cmd.c:21:1: warning: =E2=80=98static=E2=80=99 is not at begi=
nning of declaration [-Wold-style-declaration]
   21 | const static int padding_bytes =3D 26;
      | ^~~~~
