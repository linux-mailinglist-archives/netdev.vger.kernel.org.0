Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083516B90CA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCNK6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjCNK6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:58:22 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DB3BB90;
        Tue, 14 Mar 2023 03:58:18 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id EAEA45FD5D;
        Tue, 14 Mar 2023 13:58:16 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678791497;
        bh=/pHTNPqVG9LjZ2i7GbKfxAeDrLL8gxqieH3TCXC4jMM=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=kPA5kc+vDieZL8rAXzhAUizMtoR/4Bo7CjcEjqCa9wJcX63MSv0CMuyRG9s6iXlz4
         IPX08UKtjpf3/vCAlnIrLom6Zy9U2ryWOsTvZ35kHqndjzIpXptiZwJWfj/Piu0yI0
         55lpFbr/EBDUEt8SLTnYEimokK1zbAwH3gi3veB1jYoJLlqXCL/zUXQGwtWSpJW4oj
         aXzaWgSN+AMi8Egv9LnW2jQAT1MHOCSvd6yEG7Ane2DrWROcf7g8ZAQDxt3eWVavMb
         BXEMJNcvIJynSQqM1zhBp6gEQSKVESQtLWhKnqmHHLAGawvh5Wfaft8X3gBpYauRde
         j2hdJPYnrO8dw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 14 Mar 2023 13:58:14 +0300 (MSK)
Message-ID: <600992dc-1af7-7f68-ec5d-797d0da07b66@sberdevices.ru>
Date:   Tue, 14 Mar 2023 13:55:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v4 4/4] test/vsock: copy to user failure test
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <95dae024-a3f0-32e6-97a8-afde6bea9740@sberdevices.ru>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <95dae024-a3f0-32e6-97a8-afde6bea9740@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/14 06:01:00 #20942017
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hmmm, that's really strange, i don't see CV in mailing lists. Here it is anyway:

Subject: [PATCH net v4 0/4] several updates to virtio/vsock

Hello,

this patchset evolved from previous v2 version (see link below). It does
several updates to virtio/vsock:
1) Changes 'virtio_transport_inc/dec_rx_pkt()' interface. Now instead of
   using skbuff state ('head' and 'data' pointers) to update 'fwd_cnt'
   and 'rx_bytes', integer value is passed as an input argument. This
   makes code more simple, because in this case we don't need to update
   skbuff state before calling 'virtio_transport_inc/dec_rx_pkt()'. In
   more common words - we don't need to change skbuff state to update
   'rx_bytes' and 'fwd_cnt' correctly.
2) For SOCK_STREAM, when copying data to user fails, current skbuff is
   not dropped. Next read attempt will use same skbuff and last offset.
   Instead of 'skb_dequeue()', 'skb_peek()' + '__skb_unlink()' are used.
   This behaviour was implemented before skbuff support.
3) For SOCK_SEQPACKET it removes unneeded 'skb_pull()' call, because for
   this type of socket each skbuff is used only once: after removing it
   from socket's queue, it will be freed anyway.

Test for 2) also added:
Test tries to 'recv()' data to NULL buffer, then does 'recv()' with valid
buffer. For SOCK_STREAM second 'recv()' must return data, because skbuff
must not be dropped, but for SOCK_SEQPACKET skbuff will be dropped by
kernel, and 'recv()' will return EAGAIN.

Link to v1 on lore:
https://lore.kernel.org/netdev/c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru/

Link to v2 on lore:
https://lore.kernel.org/netdev/a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru/

Link to v3 on lore:
https://lore.kernel.org/netdev/0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru/

Change log:

v1 -> v2:
 - For SOCK_SEQPACKET call 'skb_pull()' also in case of copy failure or
   dropping skbuff (when we just waiting message end).
 - Handle copy failure for SOCK_STREAM in the same manner (plus free
   current skbuff).
 - Replace bug repdroducer with new test in vsock_test.c

v2 -> v3:
 - Replace patch which removes 'skb->len' subtraction from function
   'virtio_transport_dec_rx_pkt()' with patch which updates functions
   'virtio_transport_inc/dec_rx_pkt()' by passing integer argument
   instead of skbuff pointer.
 - Replace patch which drops skbuff when copying to user fails with
   patch which changes this behaviour by keeping skbuff in queue until
   it has no data.
 - Add patch for SOCK_SEQPACKET which removes redundant 'skb_pull()'
   call on read.
 - I remove "Fixes" tag from all patches, because all of them now change
   code logic, not only fix something.

v3 -> v4:
 - Update commit messages in all patches except test.
 - Add "Fixes" tag to all patches except test.

Arseniy Krasnov (4):
  virtio/vsock: don't use skbuff state to account credit
  virtio/vsock: remove redundant 'skb_pull()' call
  virtio/vsock: don't drop skbuff on copy failure
  test/vsock: copy to user failure test

 net/vmw_vsock/virtio_transport_common.c |  29 +++---
 tools/testing/vsock/vsock_test.c        | 118 ++++++++++++++++++++++++
 2 files changed, 131 insertions(+), 16 deletions(-)

-- 
2.25.1


On 14.03.2023 13:47, Arseniy Krasnov wrote:
> This adds SOCK_STREAM and SOCK_SEQPACKET tests for invalid buffer case.
> It tries to read data to NULL buffer (data already presents in socket's
> queue), then uses valid buffer. For SOCK_STREAM second read must return
> data, because skbuff is not dropped, but for SOCK_SEQPACKET skbuff will
> be dropped by kernel, and 'recv()' will return EAGAIN.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  tools/testing/vsock/vsock_test.c | 118 +++++++++++++++++++++++++++++++
>  1 file changed, 118 insertions(+)
> 
> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> index 67e9f9df3a8c..3de10dbb50f5 100644
> --- a/tools/testing/vsock/vsock_test.c
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -860,6 +860,114 @@ static void test_stream_poll_rcvlowat_client(const struct test_opts *opts)
>  	close(fd);
>  }
>  
> +#define INV_BUF_TEST_DATA_LEN 512
> +
> +static void test_inv_buf_client(const struct test_opts *opts, bool stream)
> +{
> +	unsigned char data[INV_BUF_TEST_DATA_LEN] = {0};
> +	ssize_t ret;
> +	int fd;
> +
> +	if (stream)
> +		fd = vsock_stream_connect(opts->peer_cid, 1234);
> +	else
> +		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
> +
> +	if (fd < 0) {
> +		perror("connect");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	control_expectln("SENDDONE");
> +
> +	/* Use invalid buffer here. */
> +	ret = recv(fd, NULL, sizeof(data), 0);
> +	if (ret != -1) {
> +		fprintf(stderr, "expected recv(2) failure, got %zi\n", ret);
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	if (errno != ENOMEM) {
> +		fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	ret = recv(fd, data, sizeof(data), MSG_DONTWAIT);
> +
> +	if (stream) {
> +		/* For SOCK_STREAM we must continue reading. */
> +		if (ret != sizeof(data)) {
> +			fprintf(stderr, "expected recv(2) success, got %zi\n", ret);
> +			exit(EXIT_FAILURE);
> +		}
> +		/* Don't check errno in case of success. */
> +	} else {
> +		/* For SOCK_SEQPACKET socket's queue must be empty. */
> +		if (ret != -1) {
> +			fprintf(stderr, "expected recv(2) failure, got %zi\n", ret);
> +			exit(EXIT_FAILURE);
> +		}
> +
> +		if (errno != EAGAIN) {
> +			fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> +
> +	control_writeln("DONE");
> +
> +	close(fd);
> +}
> +
> +static void test_inv_buf_server(const struct test_opts *opts, bool stream)
> +{
> +	unsigned char data[INV_BUF_TEST_DATA_LEN] = {0};
> +	ssize_t res;
> +	int fd;
> +
> +	if (stream)
> +		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
> +	else
> +		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
> +
> +	if (fd < 0) {
> +		perror("accept");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	res = send(fd, data, sizeof(data), 0);
> +	if (res != sizeof(data)) {
> +		fprintf(stderr, "unexpected send(2) result %zi\n", res);
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	control_writeln("SENDDONE");
> +
> +	control_expectln("DONE");
> +
> +	close(fd);
> +}
> +
> +static void test_stream_inv_buf_client(const struct test_opts *opts)
> +{
> +	test_inv_buf_client(opts, true);
> +}
> +
> +static void test_stream_inv_buf_server(const struct test_opts *opts)
> +{
> +	test_inv_buf_server(opts, true);
> +}
> +
> +static void test_seqpacket_inv_buf_client(const struct test_opts *opts)
> +{
> +	test_inv_buf_client(opts, false);
> +}
> +
> +static void test_seqpacket_inv_buf_server(const struct test_opts *opts)
> +{
> +	test_inv_buf_server(opts, false);
> +}
> +
>  static struct test_case test_cases[] = {
>  	{
>  		.name = "SOCK_STREAM connection reset",
> @@ -920,6 +1028,16 @@ static struct test_case test_cases[] = {
>  		.run_client = test_seqpacket_bigmsg_client,
>  		.run_server = test_seqpacket_bigmsg_server,
>  	},
> +	{
> +		.name = "SOCK_STREAM test invalid buffer",
> +		.run_client = test_stream_inv_buf_client,
> +		.run_server = test_stream_inv_buf_server,
> +	},
> +	{
> +		.name = "SOCK_SEQPACKET test invalid buffer",
> +		.run_client = test_seqpacket_inv_buf_client,
> +		.run_server = test_seqpacket_inv_buf_server,
> +	},
>  	{},
>  };
>  
