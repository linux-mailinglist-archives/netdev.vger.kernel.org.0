Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C8767EC62
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 18:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbjA0R0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 12:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbjA0R0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:26:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB7827492;
        Fri, 27 Jan 2023 09:26:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E49BF61D1F;
        Fri, 27 Jan 2023 17:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5B1C433D2;
        Fri, 27 Jan 2023 17:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674840388;
        bh=1jsBv8VGrSqlwyR16vkDOvNsvMCqTEjTtOqRmmrh4VA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DU9/oJ4I6tbLKMROZH/nsYDs0hAQa+Ag3UagYDh6znb9SePA4thYxTvfj2eak0JgR
         Ydi/5Ttel60DyHAKoqWLJVMKjGgCCyZBUEYu61d0iJnFqCg4YGjxJXP/tGgmLcI3JP
         mAjzCsl9DyRKk2TAdj2B3Y4udU5He3n5pMam1QLgw375wgoHcpVjzKrbwvDzmempc3
         qdNBhNfXl9yi6boVe848O6BMmAcySnP1LhURKLvwnWg8yQOs0GQRHIxQCBnEIONHMM
         qvKNYUStRl+ruT6ObQXqw8nI1z+J81IwSCMHSYIRsOycGGtSMZv7uErQfsl8P/hJwk
         cLKWxg8xfAvkw==
Date:   Fri, 27 Jan 2023 18:26:24 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        martin.lau@linux.dev
Subject: Re: [PATCH v3 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
Message-ID: <Y9QJQHq8X9HZxoW3@lore-desk>
References: <cover.1674737592.git.lorenzo@kernel.org>
 <0b05b08d4579b017dd96869d1329cd82801bd803.1674737592.git.lorenzo@kernel.org>
 <Y9LIPaojtpTjYlNu@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="A5mPBtMhiEowpqWr"
Content-Disposition: inline
In-Reply-To: <Y9LIPaojtpTjYlNu@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--A5mPBtMhiEowpqWr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 01/26, Lorenzo Bianconi wrote:

[...]

>=20
> Why do we need the namespaces? Why not have two veth peers in the
> current namespace?

I think we can use just a veth pair here, we do not need two, I will fix it.

>=20
> (not sure it matters, just wondering)
>=20
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

[...]
>=20
> IIRC, Martin mentioned IPv6 support in the previous version. Should we
> also make the userspace v6 aware by at least using AF_INET6 dualstack
> sockets? I feel like listening on inaddr_any with AF_INET6 should
> get us there without too much pain..

ack, I will fix it.

>=20
> > +
> > +	/* start echo channel */
> > +	*echo_sockfd =3D sockfd;
> > +	err =3D pthread_create(t, NULL, dut_echo_thread, echo_sockfd);
> > +	if (err) {
> > +		fprintf(stderr, "Failed creating dut_echo thread: %s\n",
> > +			strerror(-err));
> > +		close(sockfd);
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int dut_attach_xdp_prog(struct xdp_features *skel, int feature,
> > +			       int flags)
> > +{
> > +	struct bpf_program *prog;
> > +	unsigned int key =3D 0;
> > +	int err, fd =3D 0;
> > +
> > +	switch (feature) {
> > +	case XDP_FEATURE_TX:
> > +		prog =3D skel->progs.xdp_do_tx;
> > +		break;
> > +	case XDP_FEATURE_DROP:
> > +	case XDP_FEATURE_ABORTED:
> > +		prog =3D skel->progs.xdp_do_drop;
> > +		break;
> > +	case XDP_FEATURE_PASS:
> > +		prog =3D skel->progs.xdp_do_pass;
> > +		break;
> > +	case XDP_FEATURE_NDO_XMIT: {
> > +		struct bpf_devmap_val entry =3D {
> > +			.ifindex =3D env.ifindex,
> > +		};
> > +
> > +		err =3D bpf_map__update_elem(skel->maps.dev_map,
> > +					   &key, sizeof(key),
> > +					   &entry, sizeof(entry), 0);
> > +		if (err < 0)
> > +			return err;
> > +
> > +		fd =3D bpf_program__fd(skel->progs.xdp_do_redirect_cpumap);
> > +	}
> > +	case XDP_FEATURE_REDIRECT: {
> > +		struct bpf_cpumap_val entry =3D {
> > +			.qsize =3D 2048,
> > +			.bpf_prog.fd =3D fd,
> > +		};
> > +
> > +		err =3D bpf_map__update_elem(skel->maps.cpu_map,
> > +					   &key, sizeof(key),
> > +					   &entry, sizeof(entry), 0);
> > +		if (err < 0)
> > +			return err;
> > +
> > +		prog =3D skel->progs.xdp_do_redirect;
> > +		break;
> > +	}
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	err =3D bpf_xdp_attach(env.ifindex, bpf_program__fd(prog), flags, NUL=
L);
> > +	if (err)
> > +		fprintf(stderr,
> > +			"Failed to attach XDP program to ifindex %d\n",
> > +			env.ifindex);
> > +	return err;
> > +}
> > +
> > +static int __recv_msg(int sockfd, void *buf, size_t bufsize,
> > +		      unsigned int *val, unsigned int val_size)
> > +{
> > +	struct tlv_hdr *tlv =3D (struct tlv_hdr *)buf;
> > +	int len, n =3D sizeof(*tlv), i =3D 0;
> > +
> > +	len =3D recv(sockfd, buf, bufsize, 0);
> > +	if (len !=3D ntohs(tlv->len))
> > +		return -EINVAL;
> > +
> > +	while (n < len && i < val_size) {
> > +		val[i] =3D ntohl(tlv->data[i]);
> > +		n +=3D sizeof(tlv->data[0]);
> > +		i++;
> > +	}
> > +
> > +	return i;
> > +}
> > +
> > +static int recv_msg(int sockfd, void *buf, size_t bufsize)
> > +{
> > +	return __recv_msg(sockfd, buf, bufsize, NULL, 0);
> > +}
> > +
> > +static int dut_run(struct xdp_features *skel)
> > +{
> > +	int flags =3D XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_DRV_MODE;
> > +	int state, err, sockfd, ctrl_sockfd, echo_sockfd, optval =3D 1;
> > +	struct sockaddr_in ctrl_addr, addr =3D {
> > +		.sin_family =3D AF_INET,
> > +		.sin_addr.s_addr =3D htonl(INADDR_ANY),
> > +		.sin_port =3D htons(DUT_CTRL_PORT),
> > +	};
> > +	unsigned int len =3D sizeof(ctrl_addr);
> > +	pthread_t dut_thread;
> > +
>=20
> [..]
>=20
> > +	sockfd =3D socket(AF_INET, SOCK_STREAM, 0);
> > +	if (sockfd < 0) {
> > +		fprintf(stderr, "Failed to create DUT socket\n");
> > +		return -errno;
> > +	}
> > +
> > +	err =3D setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &optval,
> > +			 sizeof(optval));
> > +	if (err < 0) {
> > +		fprintf(stderr, "Failed sockopt on DUT socket\n");
> > +		return -errno;
> > +	}
> > +
> > +	err =3D bind(sockfd, (struct sockaddr *)&addr, sizeof(addr));
> > +	if (err < 0) {
> > +		fprintf(stderr, "Failed to bind DUT socket\n");
> > +		return -errno;
> > +	}
> > +
> > +	err =3D listen(sockfd, 5);
> > +	if (err) {
> > +		fprintf(stderr, "Failed to listen DUT socket\n");
> > +		return -errno;
> > +	}
>=20
> Should we use start_server from network_helpers.h here?

ack, I will use it.

>=20
> > +
> > +	ctrl_sockfd =3D accept(sockfd, (struct sockaddr *)&ctrl_addr, &len);
> > +	if (ctrl_sockfd < 0) {
> > +		fprintf(stderr, "Failed to accept connection on DUT socket\n");
> > +		close(sockfd);
> > +		return -errno;
> > +	}
> > +

[...]

>=20
> There is also connect_to_fd, maybe we can use that? It should take
> care of the timeouts.. (requires plumbing server_fd, not sure whether
> it's a problem or not)

please correct me if I am wrong, but in order to have server_fd it is manda=
tory
both tester and DUT are running on the same process, right? Here, I guess 9=
9% of
the times DUT and tester will run on two separated devices. Agree?

Regards,
Lorenzo

>=20
> > +
> > +	if (i =3D=3D 10) {
> > +		fprintf(stderr, "Failed to connect to the DUT\n");
> > +		return -ETIMEDOUT;
> > +	}
> > +
> > +	err =3D __send_and_recv_msg(sockfd, CMD_GET_XDP_CAP, val,
> > ARRAY_SIZE(val));
> > +	if (err < 0) {
> > +		close(sockfd);
> > +		return err;
> > +	}
> > +
> > +	advertised_cap =3D tester_collect_advertised_cap(val[0]);
> > +
> > +	err =3D bpf_xdp_attach(env.ifindex,
> > +			     bpf_program__fd(skel->progs.xdp_tester),
> > +			     flags, NULL);
> > +	if (err) {
> > +		fprintf(stderr, "Failed to attach XDP program to ifindex %d\n",
> > +			env.ifindex);
> > +		goto out;
> > +	}
> > +
> > +	err =3D send_and_recv_msg(sockfd, CMD_START);
> > +	if (err)
> > +		goto out;
> > +
> > +	for (i =3D 0; i < 10 && !exiting; i++) {
> > +		err =3D send_echo_msg();
> > +		if (err < 0)
> > +			goto out;
> > +
> > +		sleep(1);
> > +	}
> > +
> > +	err =3D __send_and_recv_msg(sockfd, CMD_GET_STATS, val, ARRAY_SIZE(va=
l));
> > +	if (err)
> > +		goto out;
> > +
> > +	/* stop the test */
> > +	err =3D send_and_recv_msg(sockfd, CMD_STOP);
> > +	/* send a new echo message to wake echo thread of the dut */
> > +	send_echo_msg();
> > +
> > +	detected_cap =3D tester_collect_detected_cap(skel, val[0]);
> > +
> > +	fprintf(stdout, "Feature %s: [%s][%s]\n",
> > get_xdp_feature_str(env.feature),
> > +		detected_cap ? GREEN("DETECTED") : RED("NOT DETECTED"),
> > +		advertised_cap ? GREEN("ADVERTISED") : RED("NOT ADVERTISED"));
> > +out:
> > +	bpf_xdp_detach(env.ifindex, flags, NULL);
> > +	close(sockfd);
> > +	return err < 0 ? err : 0;
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	struct xdp_features *skel;
> > +	int err;
> > +
> > +	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> > +	libbpf_set_print(libbpf_print_fn);
> > +
> > +	signal(SIGINT, sig_handler);
> > +	signal(SIGTERM, sig_handler);
> > +
> > +	set_env_defaul();
> > +
> > +	/* Parse command line arguments */
> > +	err =3D argp_parse(&argp, argc, argv, 0, NULL, NULL);
> > +	if (err)
> > +		return err;
> > +
> > +	if (env.ifindex < 0) {
> > +		fprintf(stderr, "Invalid ifindex\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	/* Load and verify BPF application */
> > +	skel =3D xdp_features__open();
> > +	if (!skel) {
> > +		fprintf(stderr, "Failed to open and load BPF skeleton\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	skel->rodata->expected_feature =3D env.feature;
> > +	skel->rodata->dut_ip =3D env.dut_ip;
> > +	skel->rodata->tester_ip =3D env.tester_ip;
> > +
> > +	/* Load & verify BPF programs */
> > +	err =3D xdp_features__load(skel);
> > +	if (err) {
> > +		fprintf(stderr, "Failed to load and verify BPF skeleton\n");
> > +		goto cleanup;
> > +	}
> > +
> > +	err =3D xdp_features__attach(skel);
> > +	if (err) {
> > +		fprintf(stderr, "Failed to attach BPF skeleton\n");
> > +		goto cleanup;
> > +	}
> > +
> > +	if (env.tester) {
> > +		/* Tester */
> > +		fprintf(stdout, "Starting tester on device %d\n", env.ifindex);
> > +		err =3D tester_run(skel);
> > +	} else {
> > +		/* DUT */
> > +		fprintf(stdout, "Starting DUT on device %d\n", env.ifindex);
> > +		err =3D dut_run(skel);
> > +	}
> > +
> > +cleanup:
> > +	xdp_features__destroy(skel);
> > +
> > +	return err < 0 ? -err : 0;
> > +}
> > diff --git a/tools/testing/selftests/bpf/xdp_features.h
> > b/tools/testing/selftests/bpf/xdp_features.h
> > new file mode 100644
> > index 000000000000..28d7614c4f02
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/xdp_features.h
> > @@ -0,0 +1,33 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +/* test commands */
> > +enum test_commands {
> > +	CMD_STOP,		/* CMD */
> > +	CMD_START,		/* CMD + xdp feature */
> > +	CMD_ECHO,		/* CMD */
> > +	CMD_ACK,		/* CMD + data */
> > +	CMD_GET_XDP_CAP,	/* CMD */
> > +	CMD_GET_STATS,		/* CMD */
> > +};
> > +
> > +#define DUT_CTRL_PORT	12345
> > +#define DUT_ECHO_PORT	12346
> > +
> > +struct tlv_hdr {
> > +	__be16 type;
> > +	__be16 len;
> > +	__be32 data[];
> > +};
> > +
> > +enum {
> > +	XDP_FEATURE_ABORTED,
> > +	XDP_FEATURE_DROP,
> > +	XDP_FEATURE_PASS,
> > +	XDP_FEATURE_TX,
> > +	XDP_FEATURE_REDIRECT,
> > +	XDP_FEATURE_NDO_XMIT,
> > +	XDP_FEATURE_XSK_ZEROCOPY,
> > +	XDP_FEATURE_HW_OFFLOAD,
> > +	XDP_FEATURE_RX_SG,
> > +	XDP_FEATURE_NDO_XMIT_SG,
> > +};
> > --
> > 2.39.1
>=20

--A5mPBtMhiEowpqWr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY9QJQAAKCRA6cBh0uS2t
rLdFAQD30acz7uejJRjYCuDZjy80cUMpKU/ctkPmWxcQk41OBQD7BJiYtJ72kk5j
aj7mxDUypKQ20WQ6FcdHTH75fsC4hwY=
=WIqv
-----END PGP SIGNATURE-----

--A5mPBtMhiEowpqWr--
