Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2E9456A40
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhKSGeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:34:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhKSGeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 01:34:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C855F61154;
        Fri, 19 Nov 2021 06:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637303469;
        bh=jW5Dq6uBswP1MScJ4/SW7/bS7acRY5fSQqY8VKQcFEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oaywo2wY74gRpQiDZVeE6AYDwfgO8B9+l7tJpAu7ci744HygjuQUE8yLjjteHx0L9
         lTs+UoOu9GHom66hVzI/bMxD0C52wgz2e3hQU02mLtA3yll9HlMY4jVQB+Vy0KSkQf
         VdYP6iFF6gRN43iYwo8erPo6hbhzZWe/YqV/fQE3QomiNj2txTS8A5RBl0GFGLEOJY
         bON1zj2BsnvOVkthYg81X3kY9yKA+TTACbYIAyyZG3ofNHLjQpT484GIpVcHRxOsRP
         Hg7Ne5V8HADCXBDyc4diOuYL4294PMCDvfyKINt8fveiMe1I0oXt6/L1vhHUeuQNT7
         LlqbNw9xvPAsQ==
Date:   Thu, 18 Nov 2021 22:31:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: Re: [PATCH v4 03/10] flow_offload: add index to flow_action_entry
 structure
Message-ID: <20211118223107.183dad75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211118130805.23897-4-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
        <20211118130805.23897-4-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 14:07:58 +0100 Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>=20
> Add index to flow_action_entry structure and delete index from police and
> gate child structure.
>=20
> We make this change to offload tc action for driver to identify a tc
> action.
>=20
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

drivers/net/ethernet/mscc/ocelot_flower.c:306:43: error: =E2=80=98const str=
uct <anonymous>=E2=80=99 has no member named =E2=80=98index=E2=80=99
  306 |                         pol_ix =3D a->police.index + ocelot->vcap_p=
ol.base;
      |                                           ^
