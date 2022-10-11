Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FA95FB846
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 18:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiJKQ1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 12:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJKQ1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 12:27:17 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054B79AFF2
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 09:27:15 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 5C612240101
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 18:27:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1665505634; bh=J+eq4ffyAuphloEl1EzoA3Jm3y950dT1ZiW3Vmatqbc=;
        h=Date:From:To:Cc:Subject:From;
        b=bUeJDB+yTPn9M0LYz2gRkrOcUZ/c7k/k7D+JodkB2IC0GqNBPj7QWOOsfs5skv4VZ
         d8ifCgcNaWvycKDlV6ehykwVFTWY96gprUYK9N3wI5dtD0yqRnMLSRU/GLKIausCRd
         ey34L2svxezRqrovZU4s4kTRgtunDuJUXMzVKrBmcXuJxSHzJzsQXFgxYiGJkgIiL/
         XXc+idU88QlMeDF4lgAt4VEs6/ZrAXZY+QbziyLrJbHL9zwAVjrNGiDqWUg0TON3qr
         gMuxXseUlDkno8nNHjrnIAFZYzn+5esZZiP2UNNHP9XcO6HrhJGRmKp4Z3w9FAKRbj
         2QY63m25XaQdw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Mn1QQ0kmVz9rxH;
        Tue, 11 Oct 2022 18:27:09 +0200 (CEST)
Date:   Tue, 11 Oct 2022 16:27:06 +0000
From:   Daniel =?utf-8?Q?M=C3=BCller?= <deso@posteo.net>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lina.wang@mediatek.com
Subject: Re: [net 2/2] selftests/net: fix missing xdp_dummy
Message-ID: <20221011162706.swi5ioxetcvku2tj@muellerd-fedora-MJ0AC3F3>
References: <1665482267-30706-1-git-send-email-wangyufen@huawei.com>
 <1665482267-30706-3-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1665482267-30706-3-git-send-email-wangyufen@huawei.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 05:57:47PM +0800, Wang Yufen wrote:
> After commit afef88e65554 ("selftests/bpf: Store BPF object files with
> .bpf.o extension"), we should use xdp_dummy.bpf.o instade of xdp_dummy.o.

*instead

> 
> Fixes: afef88e65554 ("selftests/bpf: Store BPF object files with .bpf.o extension")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  tools/testing/selftests/net/udpgro.sh         | 4 ++--
>  tools/testing/selftests/net/udpgro_bench.sh   | 4 ++--
>  tools/testing/selftests/net/udpgro_frglist.sh | 4 ++--
>  tools/testing/selftests/net/udpgro_fwd.sh     | 2 +-
>  tools/testing/selftests/net/veth.sh           | 8 ++++----
>  5 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
> index ebbd0b2..e339e62 100755
> --- a/tools/testing/selftests/net/udpgro.sh
> +++ b/tools/testing/selftests/net/udpgro.sh
> @@ -34,7 +34,7 @@ cfg_veth() {
>  	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
>  	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
>  	ip -netns "${PEER_NS}" link set dev veth1 up
> -	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
> +	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.bpf.o section xdp
>  }
>  
>  run_one() {
> @@ -195,7 +195,7 @@ run_all() {
>  	return $ret
>  }
>  
> -if [ ! -f ../bpf/xdp_dummy.o ]; then
> +if [ ! -f ../bpf/xdp_dummy.bpf.o ]; then
>  	echo "Missing xdp_dummy helper. Build bpf selftest first"
>  	exit -1
>  fi
> diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
> index fad2d1a..94372ea 100755
> --- a/tools/testing/selftests/net/udpgro_bench.sh
> +++ b/tools/testing/selftests/net/udpgro_bench.sh
> @@ -34,7 +34,7 @@ run_one() {
>  	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
>  	ip -netns "${PEER_NS}" link set dev veth1 up
>  
> -	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
> +	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.bpf.o section xdp
>  	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
>  	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
>  
> @@ -80,7 +80,7 @@ run_all() {
>  	run_udp "${ipv6_args}"
>  }
>  
> -if [ ! -f ../bpf/xdp_dummy.o ]; then
> +if [ ! -f ../bpf/xdp_dummy.bpf.o ]; then
>  	echo "Missing xdp_dummy helper. Build bpf selftest first"
>  	exit -1
>  fi
> diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
> index be71583..6d51156 100755
> --- a/tools/testing/selftests/net/udpgro_frglist.sh
> +++ b/tools/testing/selftests/net/udpgro_frglist.sh
> @@ -36,7 +36,7 @@ run_one() {
>  	ip netns exec "${PEER_NS}" ethtool -K veth1 rx-gro-list on
>  
>  
> -	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
> +	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.bpf.o section xdp
>  	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
>  	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.bpf.o section schedcls/ingress6/nat_6  direct-action
>  	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.bpf.o section schedcls/egress4/snat4 direct-action
> @@ -81,7 +81,7 @@ run_all() {
>  	run_udp "${ipv6_args}"
>  }
>  
> -if [ ! -f ../bpf/xdp_dummy.o ]; then
> +if [ ! -f ../bpf/xdp_dummy.bpf.o ]; then
>  	echo "Missing xdp_dummy helper. Build bpf selftest first"
>  	exit -1
>  fi
> diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
> index 1bcd82e..0c32ee4 100755
> --- a/tools/testing/selftests/net/udpgro_fwd.sh
> +++ b/tools/testing/selftests/net/udpgro_fwd.sh
> @@ -46,7 +46,7 @@ create_ns() {
>  		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V4$ns/24
>  		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V6$ns/64 nodad
>  	done
> -	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
> +	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.bpf.o section xdp 2>/dev/null
>  }
>  
>  create_vxlan_endpoint() {
> diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
> index 430895d..704cba3 100755
> --- a/tools/testing/selftests/net/veth.sh
> +++ b/tools/testing/selftests/net/veth.sh
> @@ -216,7 +216,7 @@ while getopts "hs:" option; do
>  	esac
>  done
>  
> -if [ ! -f ../bpf/xdp_dummy.o ]; then
> +if [ ! -f ../bpf/xdp_dummy.bpf.o ]; then
>  	echo "Missing xdp_dummy helper. Build bpf selftest first"
>  	exit 1
>  fi
> @@ -288,14 +288,14 @@ if [ $CPUS -gt 1 ]; then
>  	ip netns exec $NS_DST ethtool -L veth$DST rx 1 tx 2 2>/dev/null
>  	ip netns exec $NS_SRC ethtool -L veth$SRC rx 1 tx 2 2>/dev/null
>  	printf "%-60s" "bad setting: XDP with RX nr less than TX"
> -	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
> +	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.bpf.o \
>  		section xdp 2>/dev/null &&\
>  		echo "fail - set operation successful ?!?" || echo " ok "
>  
>  	# the following tests will run with multiple channels active
>  	ip netns exec $NS_SRC ethtool -L veth$SRC rx 2
>  	ip netns exec $NS_DST ethtool -L veth$DST rx 2
> -	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
> +	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.bpf.o \
>  		section xdp 2>/dev/null
>  	printf "%-60s" "bad setting: reducing RX nr below peer TX with XDP set"
>  	ip netns exec $NS_DST ethtool -L veth$DST rx 1 2>/dev/null &&\
> @@ -311,7 +311,7 @@ if [ $CPUS -gt 2 ]; then
>  	chk_channels "setting invalid channels nr" $DST 2 2
>  fi
>  
> -ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
> +ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.bpf.o section xdp 2>/dev/null
>  chk_gro_flag "with xdp attached - gro flag" $DST on
>  chk_gro_flag "        - peer gro flag" $SRC off
>  chk_tso_flag "        - tso flag" $SRC off
> -- 
> 1.8.3.1
> 

The change looks good to me. Sorry for the breakage. We should probably figure
out if it would make sense tun run these tests in BPF CI (assuming that would be
doable with reasonable effort).

Acked-by: Daniel Müller <deso@posteo.net>
