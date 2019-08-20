Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF94961F1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfHTOHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:07:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbfHTOHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:07:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD665A35FE8;
        Tue, 20 Aug 2019 14:07:34 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5FC03DE5;
        Tue, 20 Aug 2019 14:07:30 +0000 (UTC)
Date:   Tue, 20 Aug 2019 16:07:26 +0200
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: bpf: install files test_xdp_vlan.sh
Message-ID: <20190820160726.5a8990c8@carbon>
In-Reply-To: <20190820134121.25728-1-anders.roxell@linaro.org>
References: <20190820134121.25728-1-anders.roxell@linaro.org>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 20 Aug 2019 14:07:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 15:41:21 +0200
Anders Roxell <anders.roxell@linaro.org> wrote:

> When ./test_xdp_vlan_mode_generic.sh runs it complains that it can't
> find file test_xdp_vlan.sh.
> 
>  # selftests: bpf: test_xdp_vlan_mode_generic.sh
>  # ./test_xdp_vlan_mode_generic.sh: line 9: ./test_xdp_vlan.sh: No such
>  file or directory
> 
> Rework so that test_xdp_vlan.sh gets installed, added to the variable
> TEST_PROGS_EXTENDED.
> 
> Fixes: d35661fcf95d ("selftests/bpf: add wrapper scripts for test_xdp_vlan.sh")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---

Thanks for catching this!

Acked-by: Jesper Dangaard Brouer <jbrouer@redhat.com>

>  tools/testing/selftests/bpf/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 1faad0c3c3c9..d7968e20463c 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -68,7 +68,8 @@ TEST_PROGS := test_kmod.sh \
>  TEST_PROGS_EXTENDED := with_addr.sh \
>  	with_tunnels.sh \
>  	tcp_client.py \
> -	tcp_server.py
> +	tcp_server.py \
> +	test_xdp_vlan.sh
>  
>  # Compile but not part of 'make run_tests'
>  TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr test_skb_cgroup_id_user \



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
