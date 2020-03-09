Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861FB17EC34
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgCIWiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgCIWiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 18:38:20 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BAA32253D;
        Mon,  9 Mar 2020 22:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583793500;
        bh=frXXcmIpTDko2faNTmY0WkCxJjwj8UHhxbfx7OYtnBA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0DdSsTtfT1pfp18DWeJqgqtRSWl0zWtm511ybY2iC78Ik9UiBebDEXnH/oH6Y+l52
         ouhxVOrXK1Etv07Mefok7NLYxTP1zckuTU7nmxcZMLVVyAyLKfoIbdoxdLwQLfkKHK
         MSN1etz99X8VP8RKB+vWySGzByE/1x0fors1M/JI=
Date:   Mon, 9 Mar 2020 15:38:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <pablo@netfilter.org>,
        <mlxsw@mellanox.com>
Subject: Re: [patch net-next v4 01/10] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200309153817.47c97707@kicinski-fedora-PC1C0HJN>
In-Reply-To: <75b7e941-9a94-9939-f212-03aaed856088@solarflare.com>
References: <20200307114020.8664-1-jiri@resnulli.us>
        <20200307114020.8664-2-jiri@resnulli.us>
        <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
        <20200309143630.2f83476f@kicinski-fedora-PC1C0HJN>
        <75b7e941-9a94-9939-f212-03aaed856088@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Mar 2020 22:27:59 +0000 Edward Cree wrote:
> > Driver author can understandably try to simply handle all the values=20
> > in a switch statement and be unpleasantly surprised. =20
> In my experience, unenumerated enum values of this kind are fully
> =C2=A0idiomatic C; and a driver author looking at the header file to see
> =C2=A0what enumeration constants are defined will necessarily see all the
> =C2=A0calls to BIT() and the bitwise-or construction of _ANY.
> I'm not sure I believe a na=C3=AFve switch() implementation is an
> =C2=A0"understandable" error.

Could be my slight exposure to HDLs that makes me strongly averse to
encoding state outside of a enumeration into a value of that type :)

> How about if we also rename the field "hw_stats_types", or squeeze
> =C2=A0the word "mask" in there somewhere?

That'd make things slightly better.
