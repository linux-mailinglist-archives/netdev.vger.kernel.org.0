Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB831A5FAC
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 20:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgDLSLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 14:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbgDLSLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 14:11:48 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EF8C0A3BF2
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 11:11:48 -0700 (PDT)
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA402206DA;
        Sun, 12 Apr 2020 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586715108;
        bh=UOFnkDfhr2xzUMqodulCwVYAwnPtS1JZ53XWpTriPE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yjUun18GgBEkjAnrD9wbvhW+WJreCepI3S9tvp2OkVak4ogmWr/hdT2F1x0zzLrpk
         FJUwF57ETc6Q8sptdAawJBqBtczyWCbmcv/hTYrrpG2TzmbtWrCd6tKySKgf6srgyd
         NSrm5HrOak64zlPU2+4Q2fO2CHjODYt+XnbuLYbc=
Date:   Sun, 12 Apr 2020 11:11:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCH bpf] xdp: Reset prog in dev_change_xdp_fd when fd is
 negative
Message-ID: <20200412111146.523aafa5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200412133204.43847-1-dsahern@kernel.org>
References: <20200412133204.43847-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Apr 2020 07:32:04 -0600 David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
>=20
> The commit mentioned in the Fixes tag reuses the local prog variable
> when looking up an expected_fd. The variable is not reset when fd < 0
> causing a detach with the expected_fd set to actually call
> dev_xdp_install for the existing program. The end result is that the
> detach does not happen.
>=20
> Fixes: 92234c8f15c8 ("xdp: Support specifying expected existing program w=
hen attaching XDP")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
