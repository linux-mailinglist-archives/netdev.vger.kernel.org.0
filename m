Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB763AA7D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiK1OHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiK1OHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:07:17 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3F621880;
        Mon, 28 Nov 2022 06:07:01 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z92so5104818ede.1;
        Mon, 28 Nov 2022 06:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XPZ1yEYU+LcQuFKSfm/DvZBF++ncKeX+yPp3Nyjodac=;
        b=W/G2U7QDAYEQqo5ASUuXL1K7xXq11C2mpJqjXntBZ/lVDqxNyNXm6QIFB0kBkrnh0Y
         THJ7hV16LFZZTecJc/glAARr1O9a3Z82X5QQWnK6quxiS3Gq1/soYSOIpTwmhy1KnXrn
         IJAWL0T026U0A8l4u7K3OHDNURF1LPav62kX2/VVZUXCzaaawjA2ztwnbBX7eAVr7pGY
         dKldZ68vCsdRIdTkXvozFiqwisVQX5ukEJyfx5ZrY15sEA7pl3NP0qhyPxXgssWwjaTv
         2PvP6FkMptInplGIaiGTAh9cF3ISS7aG7kvUaccjWDTkl6DBuo57bgH+LiVWXogX60z2
         sTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XPZ1yEYU+LcQuFKSfm/DvZBF++ncKeX+yPp3Nyjodac=;
        b=mYXpIJVhZj+/dQfatP88Cq5iJxfz9Cbxyz5W2dMJrjds2ua70sdTpotxTHUM9sJVUE
         hIXCpj/InLjmWAMBKau8j6ztstFF1TgQE9BOzs9YSSl15KaaAR12Cfr5aYrs7nItN0K3
         bG7XXVRaG9PsH1cmMXjPV5FZHK0aeyJpLoHOUKtVqJbJz1TMaxS9xNkwr6rFZCoHakIz
         JnVOBsewl+yOIzt7jnNiGQH1EEbuJsxWxEZFAKfk/wxA83dwxlMf52i4NWwXEBXXAfhj
         QoJ8j83B4CmLoYiD5yVSJYEJmereS8aMoHNL+HJydhPn5SoiLcRZkXabQX2JBu0SkTwO
         YWPQ==
X-Gm-Message-State: ANoB5pmhhfhZrf5XMoY7KASor2H1U0QPOGmPXOb7rHf+0fetcfGO4VAN
        a+1zD30XtHXmoQLzM1sjv/U=
X-Google-Smtp-Source: AA0mqf5Us/FCVkHVWVt2eQM2DDH17wgN8KA2NZ9LEEnWTsrqQzt9sGX/sSKGU4K2bF8URsZvv9anWg==
X-Received: by 2002:a05:6402:5c7:b0:469:6e8f:74c1 with SMTP id n7-20020a05640205c700b004696e8f74c1mr29979452edx.334.1669644420057;
        Mon, 28 Nov 2022 06:07:00 -0800 (PST)
Received: from ?IPV6:2a04:241e:502:a080:dd7d:f55:c470:bcc1? ([2a04:241e:502:a080:dd7d:f55:c470:bcc1])
        by smtp.gmail.com with ESMTPSA id hh1-20020a170906a94100b007bdc2de90e6sm3062569ejb.42.2022.11.28.06.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 06:06:57 -0800 (PST)
Message-ID: <45959f08-9d77-6585-2f21-41bfceeaabd6@gmail.com>
Date:   Mon, 28 Nov 2022 16:06:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v8 00/26] tcp: Initial support for RFC5925 auth option
Content-Language: en-US
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yonatan Link <ylinik@drivenets.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florin Popescu <fpopescu@drivenets.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
In-Reply-To: <cover.1662361354.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I need to inform you that I have given up on pushing this series 
upstream. This work might be continued by Yonatan Linik 
<ylinik@drivenets.com> who works for the same employer (I will stop 
working there).

The main reason for abandoning this is that engaging in zero-sum 
competition in upstream is the last thing I ever want to do.

--
Bye,
Leonard

On 9/5/22 10:05, Leonard Crestez wrote:
> This is similar to TCP-MD5 in functionality but it's sufficiently
> different that packet formats and interfaces are incompatible.
> Compared to TCP-MD5 more algorithms are supported and multiple keys
> can be used on the same connection but there is still no negotiation
> mechanism.
> 
> Expected use-case is protecting long-duration BGP/LDP connections
> between routers using pre-shared keys. The goal of this series is to
> allow routers using the Linux TCP stack to interoperate with vendors
> such as Cisco and Juniper. An fully-featured userspace implementation
> using this patchset exists but it is not open.
> 
> 
> A completely unrelated series that implements the same features was posted
> recently: https://lore.kernel.org/netdev/20220818170005.747015-1-dima@arista.com/
> 
> The biggest difference is that this series puts TCP-AO key on a global
> instead of per-socket list and that it attempts to make kernel-mode
> key selection decisions instead of very strictly requiring userspace
> to make all decisions.
> 
> I believe my approach greatly simplifies userspace implementation.
> The biggest difference in this iteration of the patch series is adding
> per-key lifetime values based on RFC8177 in order to implement
> kernel-mode key rollover.
> 
> Older versions still required userspace to tweak the NOSEND/NORECV flags
> and always pick rnextkeyid explicitly, but now no active "key management"
> should be required on established socket - Just set correct flags and
> expiration dates and the kernel can perform key rollover itself. You can
> see a (simple) test of that behavior here:
> 
> https://github.com/cdleonard/tcp-authopt-test/blob/main/tcp_authopt_test/test_lifetime.py
> 
> The main implementation of this behavior is patch 17.
> 
> 
> Very very old versions of this series had per-socket keys but that
> approach was prone to an issue when key change made on a listen socket
> between "synack" and "accept" did not affect the new socket.
> 
> My solution was to make keys global, the Arista solution is to require
> userspace to query the key list on accepted sockets and update them.
> This offloads responsibility for an ABI race to userspace.
> It can be made to work.
> 
> 
> Here are some known flaws and limitations:
> 
> * Crypto API is used with buffers on the stack and inside struct sock,
> this might not work on all arches. I'm currently only testing x64 VMs
> * Interaction with FASTOPEN not tested.
> * Traffic key is not cached (reducing performance).
> * All lookups examine all keys, ignoring optimization opportunities
> * Overlaping MKTs can be configured despite what RFC5925 says. This is
> considered "misconfiguration by userspace" and it would make sense for
> the kernel to be more aggressive here.
> 
> Some testing support is included in nettest and fcnal-test.sh, similar
> to the current level of tcp-md5 testing.
> 
> A more elaborate test suite using pytest and scapy is available out of
> tree: https://github.com/cdleonard/tcp-authopt-test
> There is an automatic system that runs that test suite in vagrant in
> gitlab-ci: https://gitlab.com/cdleonard/vagrantcpao
> That test suite fully covers the ABI of this patchset.
> 
> Changes for frr (obsolete): https://github.com/FRRouting/frr/pull/9442
> That PR was made early for ABI feedback, it has many issues.
> 
> Changes for yabgp (obsolete): https://github.com/cdleonard/yabgp/commits/tcp_authopt
> This was used for interoperability testing with cisco.
> Would need updates for global keys to avoid leaks.
> 
> 
> Changes since PATCH v7:
> * Add lifetime fields to struct tcp_authopt_key
> * Fix not checking MD5 after unexpected AO.
> Link to v7: https://lore.kernel.org/netdev/cover.1660852705.git.cdleonard@gmail.com/
> 
> Changes since PATCH v6:
> * Squash "remove unused noops" patch (forgot to do this before v5 send).
> * Make TCP_REPAIR_AUTHOPT fail if (!tp->repair)
> * Add {snd,rcv}_seq to struct tcp_repair_authopt next to {snd,rcv}_sne.
> The fact that internally snd_sne is maintained as a 64-bit extension of
> sne_nxt is a problem for TCP_REPAIR implementation in userspace which might
> not have access to snd_nxt during live traffic. By exposing a full 64-bit
> “recent sequence number” to userspace it's possible to ignore which exact
> SEQ number the SNE value is an extension of.
> * Fix ipv6_addr_is_prefix helper; it was incorrect and dependant on
> uninitialized stack memory. This was caught by test suite after many rebases.
> * Implement ipv4-mapped-ipv6 support, request by Eric Dumazet
> Link: https://lore.kernel.org/netdev/cover.1658815925.git.cdleonard@gmail.com/
> 
> Changes since PATCH v5:
> * Rebased on recent net-next, including recent changes refactoring md5
> * Use to skb_drop_reason
> * Fix using sock_kmalloc for key alloc but regular kfree for free. Use kmalloc
> because keys are global
> * Fix mentioning non-existent copy_from_sockopt in doc for _copy_from_sockptr_tolerant
> * If no valid keys are available for a destination then report a socket error
> instead of sending unsigned traffic
> * Remove several noop implementations which are always called from ifdef
> * Fix build issues in all scenarios, including -Werror at every point.
> * Split "tcp: Refactor tcp_inbound_md5_hash into tcp_inbound_sig_hash" into a separate commit.
> * Add TCP_AUTHOPT_FLAG_ACTIVE to distinguish between "keys configured for socket"
> and "connection authenticated". A listen socket with authentication enabled will return
> other sockets with authentication enabled on accept() but if no key is configured for the
> peer then authentication will be inactive.
> * Add support for TCP_REPAIR_AUTHOPT new sockopts which loads/saves the AO-specific
> information.
> Link: https://lore.kernel.org/netdev/cover.1643026076.git.cdleonard@gmail.com/
> 
> Changes since PATCH v4:
> * Move the traffic_key context_bytes header to stack. If it's a constant
> string then ahash can fail unexpectedly.
> * Fix allowing unsigned traffic if all keys are marked norecv.
> * Fix crashing in __tcp_authopt_alg_init on failure.
> * Try to respect the rnextkeyid from SYN on SYNACK (new patch)
> * Fix incorrect check for TCP_AUTHOPT_KEY_DEL in __tcp_authopt_select_key
> * Improve docs on __tcp_authopt_select_key
> * Fix build with CONFIG_PROC_FS=n (kernel build robot)
> * Fix build with CONFIG_IPV6=n (kernel build robot)
> Link: https://lore.kernel.org/netdev/cover.1640273966.git.cdleonard@gmail.com/
> 
> Changes since PATCH v3:
> * Made keys global (per-netns rather than per-sock).
> * Add /proc/net/tcp_authopt with a table of keys (not sockets).
> * Fix part of the shash/ahash conversion having slipped from patch 3 to patch 5
> * Fix tcp_parse_sig_options assigning NULL incorrectly when both MD5 and AO
> are disabled (kernel build robot)
> * Fix sparse endianness warnings in prefix match (kernel build robot)
> * Fix several incorrect RCU annotations reported by sparse (kernel build robot)
> Link: https://lore.kernel.org/netdev/cover.1638962992.git.cdleonard@gmail.com/
> 
> Changes since PATCH v2:
> * Protect tcp_authopt_alg_get/put_tfm with local_bh_disable instead of
> preempt_disable. This caused signature corruption when send path executing
> with BH enabled was interrupted by recv.
> * Fix accepted keyids not configured locally as "unexpected". If any key
> is configured that matches the peer then traffic MUST be signed.
> * Fix issues related to sne rollover during handshake itself. (Francesco)
> * Implement and test prefixlen (David)
> * Replace shash with ahash and reuse some of the MD5 code (Dmitry)
> * Parse md5+ao options only once in the same function (Dmitry)
> * Pass tcp_authopt_info into inbound check path, this avoids second rcu
> dereference for same packet.
> * Pass tcp_request_socket into inbound check path instead of just listen
> socket. This is required for SNE rollover during handshake and clearifies
> ISN handling.
> * Do not allow disabling via sysctl after enabling once, this is difficult
> to support well (David)
> * Verbose check for sysctl_tcp_authopt (Dmitry)
> * Use netif_index_is_l3_master (David)
> * Cleanup ipvx_addr_match (David)
> * Add a #define tcp_authopt_needed to wrap static key usage because it looks
> nicer.
> * Replace rcu_read_lock with rcu_dereference_protected in SNE updates (Eric)
> * Remove test suite
> Link: https://lore.kernel.org/netdev/cover.1635784253.git.cdleonard@gmail.com/
> 
> Changes since PATCH v1:
> * Implement Sequence Number Extension
> * Implement l3index for vrf: TCP_AUTHOPT_KEY_IFINDEX as equivalent of
> TCP_MD5SIG_FLAG_IFINDEX
> * Expand TCP-AO tests in fcnal-test.sh to near-parity with md5.
> * Show addr/port on failure similar to md5
> * Remove tox dependency from test suite (create venv directly)
> * Switch default pytest output format to TAP (kselftest standard)
> * Fix _copy_from_sockptr_tolerant stack corruption on short sockopts.
> This was covered in test but error was invisible without STACKPROTECTOR=y
> * Fix sysctl_tcp_authopt check in tcp_get_authopt_val before memset. This
> was harmless because error code is checked in getsockopt anyway.
> * Fix dropping md5 packets on all sockets with AO enabled
> * Fix checking (key->recv_id & TCP_AUTHOPT_KEY_ADDR_BIND) instead of
> key->flags in tcp_authopt_key_match_exact
> * Fix PATCH 1/19 not compiling due to missing "int err" declaration
> * Add ratelimited message for AO and MD5 both present
> * Export all symbols required by CONFIG_IPV6=m (again)
> * Fix compilation with CONFIG_TCP_AUTHOPT=y CONFIG_TCP_MD5SIG=n
> * Fix checkpatch issues
> * Pass -rrequirements.txt to tox to avoid dependency variation.
> Link: https://lore.kernel.org/netdev/cover.1632240523.git.cdleonard@gmail.com/
> 
> Changes since RFCv3:
> * Implement TCP_AUTHOPT handling for timewait and reset replies. Write
> tests to execute these paths by injecting packets with scapy
> * Handle combining md5 and authopt: if both are configured use authopt.
> * Fix locking issues around send_key, introduced in on of the later patches.
> * Handle IPv4-mapped-IPv6 addresses: it used to be that an ipv4 SYN sent
> to an ipv6 socket with TCP-AO triggered WARN
> * Implement un-namespaced sysctl disabled this feature by default
> * Allocate new key before removing any old one in setsockopt (Dmitry)
> * Remove tcp_authopt_key_info.local_id because it's no longer used (Dmitry)
> * Propagate errors from TCP_AUTHOPT getsockopt (Dmitry)
> * Fix no-longer-correct TCP_AUTHOPT_KEY_DEL docs (Dmitry)
> * Simplify crypto allocation (Eric)
> * Use kzmalloc instead of __GFP_ZERO (Eric)
> * Add static_key_false tcp_authopt_needed (Eric)
> * Clear authopt_info copied from oldsk in __tcp_authopt_openreq (Eric)
> * Replace memcmp in ipv4 and ipv6 addr comparisons (Eric)
> * Export symbols for CONFIG_IPV6=m (kernel test robot)
> * Mark more functions static (kernel test robot)
> * Fix build with CONFIG_PROVE_RCU_LIST=y (kernel test robot)
> Link: https://lore.kernel.org/netdev/cover.1629840814.git.cdleonard@gmail.com/
> 
> Changes since RFCv2:
> * Removed local_id from ABI and match on send_id/recv_id/addr
> * Add all relevant out-of-tree tests to tools/testing/selftests
> * Return an error instead of ignoring unknown flags, hopefully this makes
> it easier to extend.
> * Check sk_family before __tcp_authopt_info_get_or_create in tcp_set_authopt_key
> * Use sock_owned_by_me instead of WARN_ON(!lockdep_sock_is_held(sk))
> * Fix some intermediate build failures reported by kbuild robot
> * Improve documentation
> Link: https://lore.kernel.org/netdev/cover.1628544649.git.cdleonard@gmail.com/
> 
> Changes since RFC:
> * Split into per-topic commits for ease of review. The intermediate
> commits compile with a few "unused function" warnings and don't do
> anything useful by themselves.
> * Add ABI documention including kernel-doc on uapi
> * Fix lockdep warnings from crypto by creating pools with one shash for
> each cpu
> * Accept short options to setsockopt by padding with zeros; this
> approach allows increasing the size of the structs in the future.
> * Support for aes-128-cmac-96
> * Support for binding addresses to keys in a way similar to old tcp_md5
> * Add support for retrieving received keyid/rnextkeyid and controling
> the keyid/rnextkeyid being sent.
> Link: https://lore.kernel.org/netdev/01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com/tmp/nTkFmWKVCK/0000-cover-letter.patch
> 
> Leonard Crestez (26):
>    tcp: authopt: Initial support and key management
>    docs: Add user documentation for tcp_authopt
>    tcp: authopt: Add crypto initialization
>    tcp: Refactor tcp_sig_hash_skb_data for AO
>    tcp: authopt: Compute packet signatures
>    tcp: Refactor tcp_inbound_md5_hash into tcp_inbound_sig_hash
>    tcp: authopt: Hook into tcp core
>    tcp: authopt: Disable via sysctl by default
>    tcp: authopt: Implement Sequence Number Extension
>    tcp: ipv6: Add AO signing for tcp_v6_send_response
>    tcp: authopt: Add support for signing skb-less replies
>    tcp: ipv4: Add AO signing for skb-less replies
>    tcp: authopt: Add NOSEND/NORECV flags
>    tcp: authopt: Add initial l3index support
>    tcp: authopt: Add prefixlen support
>    tcp: authopt: Add send/recv lifetime support
>    tcp: authopt: Add key selection controls
>    tcp: authopt: Add v4mapped ipv6 address support
>    tcp: authopt: Add /proc/net/tcp_authopt listing all keys
>    tcp: authopt: If no keys are valid for send report an error
>    tcp: authopt: Try to respect rnextkeyid from SYN on SYNACK
>    tcp: authopt: Initial support for TCP_AUTHOPT_FLAG_ACTIVE
>    tcp: authopt: Initial implementation of TCP_REPAIR_AUTHOPT
>    selftests: nettest: Rename md5_prefix to key_addr_prefix
>    selftests: nettest: Initial tcp_authopt support
>    selftests: net/fcnal: Initial tcp_authopt support
> 
>   Documentation/networking/index.rst        |    1 +
>   Documentation/networking/ip-sysctl.rst    |    6 +
>   Documentation/networking/tcp_authopt.rst  |   95 +
>   include/linux/tcp.h                       |   15 +
>   include/net/dropreason.h                  |   16 +
>   include/net/net_namespace.h               |    4 +
>   include/net/netns/tcp_authopt.h           |   12 +
>   include/net/tcp.h                         |   55 +-
>   include/net/tcp_authopt.h                 |  269 +++
>   include/uapi/linux/snmp.h                 |    1 +
>   include/uapi/linux/tcp.h                  |  188 ++
>   net/ipv4/Kconfig                          |   14 +
>   net/ipv4/Makefile                         |    1 +
>   net/ipv4/proc.c                           |    1 +
>   net/ipv4/sysctl_net_ipv4.c                |   39 +
>   net/ipv4/tcp.c                            |  126 +-
>   net/ipv4/tcp_authopt.c                    | 2044 +++++++++++++++++++++
>   net/ipv4/tcp_input.c                      |   55 +-
>   net/ipv4/tcp_ipv4.c                       |  100 +-
>   net/ipv4/tcp_minisocks.c                  |   12 +
>   net/ipv4/tcp_output.c                     |  106 +-
>   net/ipv6/tcp_ipv6.c                       |   70 +-
>   tools/testing/selftests/net/fcnal-test.sh |  329 +++-
>   tools/testing/selftests/net/nettest.c     |  204 +-
>   24 files changed, 3675 insertions(+), 88 deletions(-)
>   create mode 100644 Documentation/networking/tcp_authopt.rst
>   create mode 100644 include/net/netns/tcp_authopt.h
>   create mode 100644 include/net/tcp_authopt.h
>   create mode 100644 net/ipv4/tcp_authopt.c
> 
> --
> 2.25.1
