Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A612FFAAA
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 03:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbhAVCvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 21:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbhAVCvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 21:51:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C90A22C7D;
        Fri, 22 Jan 2021 02:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611283819;
        bh=T505zVRRQUQh+JPtsAEhntuLdw9/VWiFRvImivVvXkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vv0Vct6lBHETyZd/gaxPQ912+zvgz6IUKSruc2OUOqsypyltF+ZnqZSMuXxH14ucN
         Vly7ahK256IDPQurL/mac/IJCQfwx1LsUkspUgvrviwQTKR8VYlXOcFzwYoa084ZOO
         07jLHuiKIlREf13f2HCrCJHF0Hz7YINHOnF7HXWcL81PUt/gbMxSluBjTHuIKtC+3N
         imuMCp0khkSIYecFpLGXL7Sl2eMzBmyx6vid2xAdMp/29kvfo2b2aM8BMxBQs+C1WP
         N4t145w906VtpAKaSg39ADhIrwWgs0jjdDrnQ6JliQlLbnkGUv3HDqp3O9uYUUW2pi
         n/essULx2cysw==
Date:   Thu, 21 Jan 2021 18:50:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: rename csum_not_inet to csum_type
Message-ID: <20210121185018.4ba57d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
References: <cover.1611218673.git.lucien.xin@gmail.com>
        <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 16:45:36 +0800 Xin Long wrote:
> This patch is to rename csum_not_inet to csum_type, as later
> more csum type would be introduced in the next patch.
>=20
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:1073:11: error: =E2=80=98st=
ruct sk_buff=E2=80=99 has no member named =E2=80=98csum_not_inet=E2=80=99; =
did you mean =E2=80=98csum_offset=E2=80=99?
 1073 |  if (skb->csum_not_inet || skb_is_gso(skb) ||
      |           ^~~~~~~~~~~~~
      |           csum_offset
