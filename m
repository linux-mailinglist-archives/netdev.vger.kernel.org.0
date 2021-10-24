Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8112043893B
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 15:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhJXNvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 09:51:11 -0400
Received: from mailomta18-re.btinternet.com ([213.120.69.111]:32615 "EHLO
        re-prd-fep-048.btinternet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230021AbhJXNvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 09:51:10 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Oct 2021 09:51:09 EDT
Received: from re-prd-rgout-005.btmx-prd.synchronoss.net ([10.2.54.8])
          by re-prd-fep-044.btinternet.com with ESMTP
          id <20211024134235.SENW13120.re-prd-fep-044.btinternet.com@re-prd-rgout-005.btmx-prd.synchronoss.net>;
          Sun, 24 Oct 2021 14:42:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1635082955; 
        bh=jtuRQ2KBnyuA0kJGUF9OfeUiQ3QdN3vCZph6XiwdLQQ=;
        h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:MIME-Version;
        b=AjIAIA43s7vKD7z9LJFVZvA+VOw1rOaOiLS/i/VmOcpfyU5pEaiaEucgQ677+TF8ht9YHGsL6BOGjQ9cqbRPNe40hRoKXG7UDkQVPEYJKzXV8ZaZKwD3KwoN+22M2zHrFOW+rU/rlCDsaoSrGdqKq/cLxR7UIl84mvKeDEZXFwB2aP3fi0fG4+mhl3tzVh7JVm+kOQHAKuzjRZ9wC4EErR728g0VEmU2EU01Gftc9jtAhcVse2tDuqhGnM8LLwR0mPvt64S3MbzzAscqZwkn5TcXSy1dXut0Fa2Op79lPzcG23sU6trGIm0xJc/tokmx9oP9a6G+YnK4CkQROyHBJw==
Authentication-Results: btinternet.com;
    auth=pass (LOGIN) smtp.auth=richard_c_haines@btinternet.com;
    bimi=skipped
X-SNCR-Rigid: 613A9124064D089C
X-Originating-IP: [86.148.64.8]
X-OWM-Source-IP: 86.148.64.8 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvtddrvdeffedggedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuueftkffvkffujffvgffngfevqffopdfqfgfvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkuffhvfffjghftggfggfgsehtkeertddtreejnecuhfhrohhmpeftihgthhgrrhguucfjrghinhgvshcuoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqeenucggtffrrghtthgvrhhnpeeuiedtgedtgedvffejteeffeefvdegvdetteffueeukeeujeekveekgfefffefudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenucfkphepkeeirddugeekrdeigedrkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopegludelvddrudeikedruddrudelkegnpdhinhgvthepkeeirddugeekrdeigedrkedpmhgrihhlfhhrohhmpehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmpdhrtghpthhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehjmhhorhhrihhssehnrghmvghirdhorhhgpdhrtghpthhtohepkhhusggrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhstghtphesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
        uhigqdhsvggtuhhrihhthidqmhhoughulhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhutghivghnrdigihhnsehgmhgrihhlrdgtohhmpdhrtghpthhtohepmhgrrhgtvghlohdrlhgvihhtnhgvrhesghhmrghilhdrtghomhdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehomhhoshhnrggtvgesrhgvughhrghtrdgtohhmpdhrtghpthhtohepphgruhhlsehprghulhdqmhhoohhrvgdrtghomhdprhgtphhtthhopehsvghlihhnuhigsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-SNCR-hdrdom: btinternet.com
Received: from [192.168.1.198] (86.148.64.8) by re-prd-rgout-005.btmx-prd.synchronoss.net (5.8.716.04) (authenticated as richard_c_haines@btinternet.com)
        id 613A9124064D089C; Sun, 24 Oct 2021 14:42:35 +0100
Message-ID: <abf8607d35cf4b5de1cfb14de81f2c77b7a0c2f5.camel@btinternet.com>
Subject: Re: [PATCH net 0/4] security: fixups for the security hooks in sctp
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Date:   Sun, 24 Oct 2021 14:42:25 +0100
In-Reply-To: <cover.1634884487.git.lucien.xin@gmail.com>
References: <cover.1634884487.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0 (3.42.0-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-10-22 at 02:36 -0400, Xin Long wrote:
> There are a couple of problems in the currect security hooks in sctp:
> 
> 1. The hooks incorrectly treat sctp_endpoint in SCTP as request_sock in
>    TCP, while it's in fact no more than an extension of the sock, and
>    represents the local host. It is created when sock is created, not
>    when a conn request comes. sctp_association is actually the correct
>    one to represent the connection, and created when a conn request
>    arrives.
> 
> 2. security_sctp_assoc_request() hook should also be called in
> processing
>    COOKIE ECHO, as that's the place where the real assoc is created and
>    used in the future.
> 
> The problems above may cause accept sk, peeloff sk or client sk having
> the incorrect security labels.
> 
> So this patchset is to change some hooks and pass asoc into them and
> save
> these secids into asoc, as well as add the missing sctp_assoc_request
> hook into the COOKIE ECHO processing.

I've built this patchset on kernel 5.15-rc5 with no problems.
I tested this using the SELinux testsuite with Ondrej's "[PATCH
testsuite] tests/sctp: add client peeloff tests" [1] added. All SCTP
tests ran with no errors. Also ran the sctp-tests from [2] with no
errors.

[1]
https://lore.kernel.org/selinux/20211021144543.740762-1-omosnace@redhat.com/
[2] https://github.com/sctp/sctp-tests.git

Reviewed-by: Richard Haines <richard_c_haines@btinternet.com>
Tested-by: Richard Haines <richard_c_haines@btinternet.com>

> 
> Xin Long (4):
>   security: pass asoc to sctp_assoc_request and sctp_sk_clone
>   security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce
>   security: add sctp_assoc_established hook
>   security: implement sctp_assoc_established hook in selinux
> 
>  Documentation/security/SCTP.rst     | 65 +++++++++++++++--------------
>  include/linux/lsm_hook_defs.h       |  6 ++-
>  include/linux/lsm_hooks.h           | 13 ++++--
>  include/linux/security.h            | 18 +++++---
>  include/net/sctp/structs.h          | 20 ++++-----
>  net/sctp/sm_statefuns.c             | 31 ++++++++------
>  net/sctp/socket.c                   |  5 +--
>  security/security.c                 | 15 +++++--
>  security/selinux/hooks.c            | 36 +++++++++++-----
>  security/selinux/include/netlabel.h |  4 +-
>  security/selinux/netlabel.c         | 14 +++----
>  11 files changed, 135 insertions(+), 92 deletions(-)
> 

