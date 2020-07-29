Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C286B23266F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgG2UtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2UtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 16:49:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D5FD2068F;
        Wed, 29 Jul 2020 20:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596055757;
        bh=DFkbkpNDL3EfvABI6agJV9omgpbIMq6JDETG6lDnzjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cjm3/BQ1tiEModo9uKXMYNrkf7a2hlaH6PJvvMEgwI5UYy2f0f83Ep4USVjf74gC1
         +5hR9P8VESuSXCaLGeSnTgDUw9td1LjwrEd1jO5vv22bGAAJ6zJ9cz/vbK51trBhB1
         8y2ofA2MAZptofzTOoLL2FzdiNV2oUqHB64Rb7LE=
Date:   Wed, 29 Jul 2020 13:49:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <dthompson@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        Asmaa Mnebhi <asmaa@mellanox.com>
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Message-ID: <20200729134915.5896edc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 14:29:15 -0400 David Thompson wrote:
> This patch adds build and driver logic for the "mlxbf_gige"
> Ethernet driver from Mellanox Technologies.

Please fix these W=3D1 C=3D1 warnings:

drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:256:29: warning:=
 Using plain integer as NULL pointer
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:258:29: warning:=
 Using plain integer as NULL pointer
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:292:29: warning:=
 Using plain integer as NULL pointer
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:294:23: warning:=
 Using plain integer as NULL pointer
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:296:29: warning:=
 Using plain integer as NULL pointer
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:329:25: warning:=
 incorrect type in assignment (different base types)
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:329:25:    expec=
ted unsigned long long [usertype]
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:329:25:    got r=
estricted __be64 [usertype]
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c: In function =E2=
=80=98mlxbf_gige_initial_mac=E2=80=99:
drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c:1093:6: warning:=
 variable =E2=80=98status=E2=80=99 set but not used [-Wunused-but-set-varia=
ble]
 1093 |  int status;
      |      ^~~~~~
