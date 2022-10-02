Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552A55F21FD
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJBIRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJBIRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:17:38 -0400
X-Greylist: delayed 70 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 02 Oct 2022 01:17:34 PDT
Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5AC3F1E6;
        Sun,  2 Oct 2022 01:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1664698651;
        bh=CScWYLEqhDwTIVrXOlh5cMj8TjSjE5p3uKPDNBlDjK8=;
        h=Date:From:Subject:To:Cc;
        b=IboCD5lPqZzL5G97Y3fc0KodNKhWK+JUdAD8PKQM9qhWwKk9vxUm2GF1wRaV+gVAJ
         qVvugQlJIRncCm34WLcidT1l7pY0m/WVWBI48Fxo67XMtnQKV268sDNSgjZrur8j6R
         pEbkZEjiiHXgL0bLbOORIRcDhjcmBR7qMJwbULkk=
Received: from [10.30.0.92] ([211.137.109.91])
        by newxmesmtplogicsvrsza7.qq.com (NewEsmtp) with SMTP
        id 41185641; Sun, 02 Oct 2022 16:16:17 +0800
X-QQ-mid: xmsmtpt1664698577tijmy8v5f
Message-ID: <tencent_BC846D74CA86E95DAC48E65686FEE6359C07@qq.com>
X-QQ-XMAILINFO: NJ/+omVLhVga5ZIxJMxFEofYJGNhuUPZVurakmoNJkufXejGvti1sPp9chS2Yh
         3PweHkIrh98XIy1PwibR1SIkZVXkqMe3x3vfz9syxjB9suCoPZS7Zze46/w0eFuP3L4E6iCnlHVB
         ssG1SsrYEJnmebjqbWz1DkMii6HMqmCUxBuTT/fZvnsP91GJca3vY2KOagH/x/EdBlZGURT4H51+
         6kGZtRzB1s0yw12ToqHHGuz4DRNsLxKlQmeV0tBnY3+fNM4tVzJAgdsN+s1hX8NJdXPs/7as5Mz8
         HVrkcyYrqVzpkvFj3AsS/x76LFLUW6bFOUP4ABA1URdk4/0cA5KxbIl5mrl9a0wvD0MX041WmD5i
         P7jEYmTDfLrmn5sJWGw/uisOZRZs/fLzhAiNeOiEFXq5n9HEHhMsH5Y9oxO3FIUW/BIHCKe8xvwb
         txnMr01eaJRogxZjeON+DIhsu/A5RZQQUVuEV7L9aaY/zXHnaG7Hkby10CNu2rTMh3wFQ7OK9BCT
         85tWDgyrEb3NMHfH8c+QpdWII8z/iZuym0vX2jmX7Zy7ESAKSRiye8+NilheADz4OQqriQORHL41
         n3WP4Db7k9BNSkoE7DsgqSKzcSCuT+MAiiQKNUcDV8SjNKna+PQKdrmYtDUSQrIq0By+WBBa3PHC
         iXvAWkjiTHVknvxax/Ga19vI4vQBUc+gVz3gQsI4AwBmrOsXizAPpk73+BrP6Dvy8OgimR45GDnQ
         zsdM2pfH/0SARvAckkjBB1LLXGwwu6ASJYtBq144GwfTlROKhlsmNqyw3ldc+lv1HM+ruQMVrBZi
         QeO9RczT5CA7KonU5sV/TbkL1KF7Amg6QlRV6l7fGMuu9l10rxUPFZcW6kVe+ICUq7BzNyLtRmjv
         8tTxOWXmseYbW1G2oUlj/OXx09a+UqbXCNX5c5bEP154t5PxYX5UHV4cA8qzkv+M/ovak0GNmtdz
         TPMj+yDEmC6nROCC9F4MQrkA5tddpi/JZIvIIf3xWQOuT1zKsLun1YoJTkun3+Wi/NlK7l65Lh5p
         zgXwjbuQ==
X-OQ-MSGID: <6c65cfea-1fcf-9d41-b905-12305c6c3458@foxmail.com>
Date:   Sun, 2 Oct 2022 16:16:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
From:   Chen Yuanrun <chen-yuanrun@foxmail.com>
Subject: [PATCH] libceph: queue_con only if the sock is connected
To:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
Cc:     ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chen Yuanrun <chen-yuanrun@foxmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_sendmsg_locked will trigger sk->sk_write_space while the sock
is still connecting, if con try to write to a connecting sock,
sk->sk_write_space will be called again, which lead to a endless loop.

This will happen if the public network of the cluster is down, and
the cpu will be in high usage.

Signed-off-by: Chen Yuanrun <chen-yuanrun@foxmail.com>
---
  net/ceph/messenger.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d3bb656308b4..eef5d4dfd1f1 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -367,7 +367,8 @@ static void ceph_sock_write_space(struct sock *sk)
       * buffer. See net/ipv4/tcp_input.c:tcp_check_space()
       * and net/core/stream.c:sk_stream_write_space().
       */
-    if (ceph_con_flag_test(con, CEPH_CON_F_WRITE_PENDING)) {
+    if (ceph_con_flag_test(con, CEPH_CON_F_WRITE_PENDING) &&
+        atomic_read(&con->sock_state) == CON_SOCK_STATE_CONNECTED) {
          if (sk_stream_is_writeable(sk)) {
              dout("%s %p queueing write work\n", __func__, con);
              clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);

-- 
2.31.1



