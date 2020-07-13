Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39C021D7E5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgGMOKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:10:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59294 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729659AbgGMOKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594649442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e3VnvsSgbS2pei1A1BRN/7/m30X5CwoB5LEtmztoz3Y=;
        b=Z6Gz5KgMZrJbKP3VrBFtKcQqiF7GnGSrIBxvv40joE+7/jF1i44v4WiYBYl694sbG4c6JY
        MKQLiLROfa7V9LKQYgpsLRjUZ6KGWF15HkEUDu/GVs7T/B40wOtKLVpv/eDbWQPQSs2wNb
        S6LO+Pz+2+Qg3aOa7hkWNLMLyijYZ8k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-NN2iEHDJMhyOaIaA_v2jCg-1; Mon, 13 Jul 2020 10:10:38 -0400
X-MC-Unique: NN2iEHDJMhyOaIaA_v2jCg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E79488015CE;
        Mon, 13 Jul 2020 14:10:36 +0000 (UTC)
Received: from [10.10.120.78] (ovpn-120-78.rdu2.redhat.com [10.10.120.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 164597621D;
        Mon, 13 Jul 2020 14:10:35 +0000 (UTC)
Subject: Re: [PATCH net-next 18/20] net: tipc: kerneldoc fixes
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Ying Xue <ying.xue@windriver.com>
References: <20200712231516.1139335-1-andrew@lunn.ch>
 <20200712231516.1139335-19-andrew@lunn.ch>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <e857fae9-e695-1868-7e32-3aeb43976ff3@redhat.com>
Date:   Mon, 13 Jul 2020 10:10:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200712231516.1139335-19-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/20 7:15 PM, Andrew Lunn wrote:
> Simple fixes which require no deep knowledge of the code.
>
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   net/tipc/bearer.c    | 2 +-
>   net/tipc/discover.c  | 5 ++---
>   net/tipc/link.c      | 6 +++---
>   net/tipc/msg.c       | 2 +-
>   net/tipc/node.c      | 4 ++--
>   net/tipc/socket.c    | 8 +++-----
>   net/tipc/udp_media.c | 2 +-
>   7 files changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index e366ec9a7e4d..808b147df7d5 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -595,7 +595,7 @@ void tipc_bearer_bc_xmit(struct net *net, u32 bearer_id,
>   
>   /**
>    * tipc_l2_rcv_msg - handle incoming TIPC message from an interface
> - * @buf: the received packet
> + * @skb: the received message
>    * @dev: the net device that the packet was received on
>    * @pt: the packet_type structure which was used to register this handler
>    * @orig_dev: the original receive net device in case the device is a bond
> diff --git a/net/tipc/discover.c b/net/tipc/discover.c
> index bfe43da127c0..d4ecacddb40c 100644
> --- a/net/tipc/discover.c
> +++ b/net/tipc/discover.c
> @@ -74,7 +74,7 @@ struct tipc_discoverer {
>   /**
>    * tipc_disc_init_msg - initialize a link setup message
>    * @net: the applicable net namespace
> - * @type: message type (request or response)
> + * @mtyp: message type (request or response)
>    * @b: ptr to bearer issuing message
>    */
>   static void tipc_disc_init_msg(struct net *net, struct sk_buff *skb,
> @@ -339,7 +339,7 @@ static void tipc_disc_timeout(struct timer_list *t)
>    * @net: the applicable net namespace
>    * @b: ptr to bearer issuing requests
>    * @dest: destination address for request messages
> - * @dest_domain: network domain to which links can be established
> + * @skb: pointer to created frame
>    *
>    * Returns 0 if successful, otherwise -errno.
>    */
> @@ -393,7 +393,6 @@ void tipc_disc_delete(struct tipc_discoverer *d)
>    * tipc_disc_reset - reset object to send periodic link setup requests
>    * @net: the applicable net namespace
>    * @b: ptr to bearer issuing requests
> - * @dest_domain: network domain to which links can be established
>    */
>   void tipc_disc_reset(struct net *net, struct tipc_bearer *b)
>   {
> diff --git a/net/tipc/link.c b/net/tipc/link.c
> index 1c579357ccdf..6aca0ebb391a 100644
> --- a/net/tipc/link.c
> +++ b/net/tipc/link.c
> @@ -445,7 +445,7 @@ u32 tipc_link_state(struct tipc_link *l)
>   
>   /**
>    * tipc_link_create - create a new link
> - * @n: pointer to associated node
> + * @net: pointer to associated network namespace
>    * @if_name: associated interface name
>    * @bearer_id: id (index) of associated bearer
>    * @tolerance: link tolerance to be used by link
> @@ -530,7 +530,7 @@ bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
>   
>   /**
>    * tipc_link_bc_create - create new link to be used for broadcast
> - * @n: pointer to associated node
> + * @net: pointer to associated network namespace
>    * @mtu: mtu to be used initially if no peers
>    * @window: send window to be used
>    * @inputq: queue to put messages ready for delivery
> @@ -974,7 +974,7 @@ void tipc_link_reset(struct tipc_link *l)
>   
>   /**
>    * tipc_link_xmit(): enqueue buffer list according to queue situation
> - * @link: link to use
> + * @l: link to use
>    * @list: chain of buffers containing message
>    * @xmitq: returned list of packets to be sent by caller
>    *
> diff --git a/net/tipc/msg.c b/net/tipc/msg.c
> index 01b64869a173..848fae674532 100644
> --- a/net/tipc/msg.c
> +++ b/net/tipc/msg.c
> @@ -202,7 +202,7 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
>   
>   /**
>    * tipc_msg_append(): Append data to tail of an existing buffer queue
> - * @hdr: header to be used
> + * @_hdr: header to be used
>    * @m: the data to be appended
>    * @mss: max allowable size of buffer
>    * @dlen: size of data to be appended
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index 030a51c4d1fa..4edcee3088da 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -1515,7 +1515,7 @@ static void node_lost_contact(struct tipc_node *n,
>    * tipc_node_get_linkname - get the name of a link
>    *
>    * @bearer_id: id of the bearer
> - * @node: peer node address
> + * @addr: peer node address
>    * @linkname: link name output buffer
>    *
>    * Returns 0 on success
> @@ -2022,7 +2022,7 @@ static bool tipc_node_check_state(struct tipc_node *n, struct sk_buff *skb,
>    * tipc_rcv - process TIPC packets/messages arriving from off-node
>    * @net: the applicable net namespace
>    * @skb: TIPC packet
> - * @bearer: pointer to bearer message arrived on
> + * @b: pointer to bearer message arrived on
>    *
>    * Invoked with no locks held. Bearer pointer must point to a valid bearer
>    * structure (i.e. cannot be NULL), but bearer can be inactive.
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index a94f38333698..fc388cef6471 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -711,7 +711,6 @@ static int tipc_bind(struct socket *sock, struct sockaddr *uaddr,
>    * tipc_getname - get port ID of socket or peer socket
>    * @sock: socket structure
>    * @uaddr: area for returned socket address
> - * @uaddr_len: area for returned length of socket address
>    * @peer: 0 = own ID, 1 = current peer ID, 2 = current/former peer ID
>    *
>    * Returns 0 on success, errno otherwise
> @@ -1053,7 +1052,7 @@ static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
>   
>   /**
>    * tipc_send_group_bcast - send message to all members in communication group
> - * @sk: socket structure
> + * @sock: socket structure
>    * @m: message to send
>    * @dlen: total length of message data
>    * @timeout: timeout to wait for wakeup
> @@ -1673,7 +1672,7 @@ static void tipc_sk_finish_conn(struct tipc_sock *tsk, u32 peer_port,
>   /**
>    * tipc_sk_set_orig_addr - capture sender's address for received message
>    * @m: descriptor for message info
> - * @hdr: received message header
> + * @skb: received message
>    *
>    * Note: Address is not captured if not requested by receiver.
>    */
> @@ -2095,7 +2094,6 @@ static void tipc_write_space(struct sock *sk)
>   /**
>    * tipc_data_ready - wake up threads to indicate messages have been received
>    * @sk: socket
> - * @len: the length of messages
>    */
>   static void tipc_data_ready(struct sock *sk)
>   {
> @@ -2677,7 +2675,7 @@ static int tipc_wait_for_accept(struct socket *sock, long timeo)
>   /**
>    * tipc_accept - wait for connection request
>    * @sock: listening socket
> - * @newsock: new socket that is to be connected
> + * @new_sock: new socket that is to be connected
>    * @flags: file-related flags associated with socket
>    *
>    * Returns 0 on success, errno otherwise
> diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
> index 28a283f26a8d..d91b7c543e39 100644
> --- a/net/tipc/udp_media.c
> +++ b/net/tipc/udp_media.c
> @@ -565,7 +565,7 @@ int tipc_udp_nl_add_bearer_data(struct tipc_nl_msg *msg, struct tipc_bearer *b)
>   
>   /**
>    * tipc_parse_udp_addr - build udp media address from netlink data
> - * @nlattr:	netlink attribute containing sockaddr storage aligned address
> + * @nla:	netlink attribute containing sockaddr storage aligned address
>    * @addr:	tipc media address to fill with address, port and protocol type
>    * @scope_id:	IPv6 scope id pointer, not NULL indicates it's required
>    */
Thanks, Andrew
Acked-by: Jon Maloy <jmaloy@redhat.com>

