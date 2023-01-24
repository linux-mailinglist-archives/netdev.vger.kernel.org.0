Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005AF67964C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbjAXLMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjAXLMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:12:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913818685;
        Tue, 24 Jan 2023 03:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4190B81151;
        Tue, 24 Jan 2023 11:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06111C433EF;
        Tue, 24 Jan 2023 11:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674558762;
        bh=VX5KSFREMNYBtwN2SJjrbqgA/NIUxSyDN0ffRjhvy/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sTx1wSkdnUU3zgLnYUtoQWaVrs8CKpC4v5JmhB5o2krnIrHnfEl9iFNXeO0K/WeuD
         OS66bkjvMJOqF+/Qm8ZdhD8gIScOdB7q7kY45aLzng5BUyZwIQyjmk8gvULyVy2r9i
         uS+QQa6HOtYTxK46tSTZMzxQCogH3kfNALaM/KTW3o83EHR+7oBXncQR8wNWQSNhJu
         +dX52tF65nEDGtE56V9mYXUodhpNdcbfe8jHglTmpCtDrN8uWP6J9MT6teJ2VKo3Hc
         zjlNOmGdRFul0jy432GnDCosPDcFRuvmm1NS+YFk2dk+2SjTYkLlHDvB8nuJY9FXf3
         WEcci+DhkYF2Q==
Date:   Tue, 24 Jan 2023 12:12:38 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 7/7] selftests/bpf: introduce XDP compliance
 test tool
Message-ID: <Y8+9Jmhr9OSty63Y@lore-desk>
References: <cover.1674234430.git.lorenzo@kernel.org>
 <986321f8621e9367653e21b35566e7cda976b886.1674234430.git.lorenzo@kernel.org>
 <d2606312-1e04-55ff-e01e-daf83ed99836@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vXwS72sJheo8aQyw"
Content-Disposition: inline
In-Reply-To: <d2606312-1e04-55ff-e01e-daf83ed99836@linux.dev>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vXwS72sJheo8aQyw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 1/20/23 9:16 AM, Lorenzo Bianconi wrote:
> > +static __always_inline int xdp_process_echo_packet(struct xdp_md *xdp,=
 bool dut)
> > +{
> > +	void *data_end =3D (void *)(long)xdp->data_end;
> > +	__be32 saddr =3D dut ? tester_ip : dut_ip;
> > +	__be32 daddr =3D dut ? dut_ip : tester_ip;
> > +	void *data =3D (void *)(long)xdp->data;
> > +	struct ethhdr *eh =3D data;
> > +	struct tlv_hdr *tlv;
> > +	struct udphdr *uh;
> > +	struct iphdr *ih;
> > +	__be16 port;
> > +	__u8 *cmd;
> > +
> > +	if (eh + 1 > (struct ethhdr *)data_end)
> > +		return -EINVAL;
> > +
> > +	if (eh->h_proto !=3D bpf_htons(ETH_P_IP))
> > +		return -EINVAL;
>=20
> Both v6 and v4 support are needed as a tool.

ack, I will fix it.

>=20
> [ ... ]
>=20
> > diff --git a/tools/testing/selftests/bpf/test_xdp_features.sh b/tools/t=
esting/selftests/bpf/test_xdp_features.sh
> > new file mode 100755
> > index 000000000000..98b8fd2b6c16
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/test_xdp_features.sh
> > @@ -0,0 +1,99 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +# Create 2 namespaces with two veth peers, and
> > +# check reported and detected XDP capabilities
> > +#
> > +#   NS0(v00)              NS1(v11)
> > +#       |                     |
> > +#       |                     |
> > +# (v01, id:111)  ------  (v10,id:222)
> > +
> > +readonly NS0=3D"ns1-$(mktemp -u XXXXXX)"
> > +readonly NS1=3D"ns2-$(mktemp -u XXXXXX)"
> > +ret=3D1
> > +
> > +setup() {
> > +	{
> > +		ip netns add ${NS0}
> > +		ip netns add ${NS1}
> > +
> > +		ip link add v01 index 111 type veth peer name v00 netns ${NS0}
> > +		ip link add v10 index 222 type veth peer name v11 netns ${NS1}
> > +
> > +		ip link set v01 up
> > +		ip addr add 10.10.0.1/24 dev v01
> > +		ip link set v01 address 00:11:22:33:44:55
> > +		ip -n ${NS0} link set dev v00 up
> > +		ip -n ${NS0} addr add 10.10.0.11/24 dev v00
> > +		ip -n ${NS0} route add default via 10.10.0.1
> > +		ip -n ${NS0} link set v00 address 00:12:22:33:44:55
> > +
> > +		ip link set v10 up
> > +		ip addr add 10.10.1.1/24 dev v10
> > +		ip link set v10 address 00:13:22:33:44:55
> > +		ip -n ${NS1} link set dev v11 up
> > +		ip -n ${NS1} addr add 10.10.1.11/24 dev v11
> > +		ip -n ${NS1} route add default via 10.10.1.1
> > +		ip -n ${NS1} link set v11 address 00:14:22:33:44:55
> > +
> > +		sysctl -w net.ipv4.ip_forward=3D1
> > +		# Enable XDP mode
> > +		ethtool -K v01 gro on
> > +		ethtool -K v01 tx-checksumming off
> > +		ip netns exec ${NS0} ethtool -K v00 gro on
> > +		ip netns exec ${NS0} ethtool -K v00 tx-checksumming off
> > +		ethtool -K v10 gro on
> > +		ethtool -K v10 tx-checksumming off
> > +		ip netns exec ${NS1} ethtool -K v11 gro on
> > +		ip netns exec ${NS1} ethtool -K v11 tx-checksumming off
> > +	} > /dev/null 2>&1
> > +}
> > +
> > +cleanup() {
> > +	ip link del v01 2> /dev/null
> > +	ip link del v10 2> /dev/null
> > +	ip netns del ${NS0} 2> /dev/null
> > +	ip netns del ${NS1} 2> /dev/null
> > +	[ "$(pidof xdp_features)" =3D "" ] || kill $(pidof xdp_features) 2> /=
dev/null
> > +}
> > +
> > +test_xdp_features() {
> > +	setup
> > +
> > +	## XDP_PASS
> > +	ip netns exec ${NS1} ./xdp_features -f XDP_PASS -D 10.10.1.11 -T 10.1=
0.0.11 v11 &
> > +	ip netns exec ${NS0} ./xdp_features -t -f XDP_PASS -D 10.10.1.11 -C 1=
0.10.1.11 -T 10.10.0.11 v00
> > +
> > +	[ $? -ne 0 ] && exit
> > +
> > +	# XDP_DROP
> > +	ip netns exec ${NS1} ./xdp_features -f XDP_DROP -D 10.10.1.11 -T 10.1=
0.0.11 v11 &
> > +	ip netns exec ${NS0} ./xdp_features -t -f XDP_DROP -D 10.10.1.11 -C 1=
0.10.1.11 -T 10.10.0.11 v00
> > +
> > +	[ $? -ne 0 ] && exit
> > +
> > +	## XDP_TX
> > +	./xdp_features -f XDP_TX -D 10.10.0.1 -T 10.10.0.11 v01 &
> > +	ip netns exec ${NS0} ./xdp_features -t -f XDP_TX -D 10.10.0.1 -C 10.1=
0.0.1 -T 10.10.0.11 v00
> > +
> > +	## XDP_REDIRECT
> > +	ip netns exec ${NS1} ./xdp_features -f XDP_REDIRECT -D 10.10.1.11 -T =
10.10.0.11 v11 &
> > +	ip netns exec ${NS0} ./xdp_features -t -f XDP_REDIRECT -D 10.10.1.11 =
-C 10.10.1.11 -T 10.10.0.11 v00
> > +
> > +	[ $? -ne 0 ] && exit
> > +
> > +	## XDP_NDO_XMIT
> > +	./xdp_features -f XDP_NDO_XMIT -D 10.10.0.1 -T 10.10.0.11 v01 &
> > +	ip netns exec ${NS0} ./xdp_features -t -f XDP_NDO_XMIT -D 10.10.0.1 -=
C 10.10.0.1 -T 10.10.0.11 v00
> > +
> > +	ret=3D$?
> > +	cleanup
> > +}
> > +
> > +set -e
> > +trap cleanup 2 3 6 9
> > +
> > +test_xdp_features
>=20
> This won't be run by bpf CI.
>=20
> A selftest in test_progs is needed to test the libbpf changes in patch 6.

ack, I will add it.

Regards,
Lorenzo

>=20

--vXwS72sJheo8aQyw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY8+9JgAKCRA6cBh0uS2t
rAVxAQDuQpyo+82ZkOU6gyjeqezwLl9WA56TqSgJaO06eFYHVwEA6xd8k4wgRKir
+9gai1xpvVfvpukC3pmQrphAjU7O6Aw=
=frY2
-----END PGP SIGNATURE-----

--vXwS72sJheo8aQyw--
