Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55199592AAB
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 10:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbiHOHs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 03:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbiHOHsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 03:48:25 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6385A1DA45;
        Mon, 15 Aug 2022 00:48:24 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id tl27so12252101ejc.1;
        Mon, 15 Aug 2022 00:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=o07DAvynDZMFcdSR1hYmSQ0ZBEPwOh6VCwI4OLt2fcU=;
        b=p8oPw5UADTF7wX/q3KsxKV7dEngkZTA0YyXfuzjEC3qDh2j7RSodBWtrT4EKHkc7gS
         +EcVi4ySfMf7Rh3TmrutXqKuprrRi/kc6c7UA6+djEjTcaH1FhyrCNmmADXnP+XoRI7u
         6XnpQLdnyabA85/qw0Q0Bn9UefPi8y2oGfs71QRwXwMFT2Ym1oNbztNB2aR5Vf5TIzTu
         A+BApHkGMZkRZeHm2AH3OtO11/AAPO/vOxj/gWGNZlE2iJIqKDR+xjA49JztDo72dEsk
         iuwTMGlkSNoYcMxOZI2a0s+o3r+qIHL8jTmj4Xvi0stv+VhBKCG7XUawX0kULEzHyV+v
         ivWA==
X-Gm-Message-State: ACgBeo3Nszl4z+LZ5Z1nfC5I/+AIgHp5na6I/dklQu9FB+Acflsahsj4
        REU48FVRFRvRMRLIkEKOEIU=
X-Google-Smtp-Source: AA6agR6kOgPIAFe5iOHRjlZ180yOrXZTWyAv5N39FZzC9Ae/J87YVWuIJNyTwpelYiuUys/Ifjxa9A==
X-Received: by 2002:a17:907:3dab:b0:730:933d:ae69 with SMTP id he43-20020a1709073dab00b00730933dae69mr9953762ejc.500.1660549702593;
        Mon, 15 Aug 2022 00:48:22 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id b16-20020a170906491000b007336c3f05bdsm3839744ejq.178.2022.08.15.00.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 00:48:22 -0700 (PDT)
Message-ID: <f3301080-78c6-a65a-d8b1-59b759a077a4@kernel.org>
Date:   Mon, 15 Aug 2022 09:48:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        LemmyHuang <hlm3280@163.com>, stable <stable@vger.kernel.org>
References: <20220721204404.388396-1-weiwan@google.com>
 <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
 <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
 <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org>
In-Reply-To: <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06. 08. 22, 16:41, Jiri Slaby wrote:
> On 06. 08. 22, 13:24, Neal Cardwell wrote:
>> On Sat, Aug 6, 2022 at 6:02 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>>>
>>> On 21. 07. 22, 22:44, Wei Wang wrote:
>>>> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
>>>>
>>>> This to-be-reverted commit was meant to apply a stricter rule for the
>>>> stack to enter pingpong mode. However, the condition used to check for
>>>> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
>>>> jiffy based and might be too coarse, which delays the stack entering
>>>> pingpong mode.
>>>> We revert this patch so that we no longer use the above condition to
>>>> determine interactive session, and also reduce pingpong threshold to 1.
>>>>
>>>> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
>>>> Reported-by: LemmyHuang <hlm3280@163.com>
>>>> Suggested-by: Neal Cardwell <ncardwell@google.com>
>>>> Signed-off-by: Wei Wang <weiwan@google.com>
>>>
>>>
>>> This breaks python-eventlet [1] (and was backported to stable trees):
>>> ________________ TestHttpd.test_018b_http_10_keepalive_framing
>>> _________________
>>>
>>> self = <tests.wsgi_test.TestHttpd
>>> testMethod=test_018b_http_10_keepalive_framing>
>>>
>>>       def test_018b_http_10_keepalive_framing(self):
>>>           # verify that if an http/1.0 client sends connection: 
>>> keep-alive
>>>           # that we don't mangle the request framing if the app doesn't
>>> read the request
>>>           def app(environ, start_response):
>>>               resp_body = {
>>>                   '/1': b'first response',
>>>                   '/2': b'second response',
>>>                   '/3': b'third response',
>>>               }.get(environ['PATH_INFO'])
>>>               if resp_body is None:
>>>                   resp_body = 'Unexpected path: ' + environ['PATH_INFO']
>>>                   if six.PY3:
>>>                       resp_body = resp_body.encode('latin1')
>>>               # Never look at wsgi.input!
>>>               start_response('200 OK', [('Content-type', 'text/plain')])
>>>               return [resp_body]
>>>
>>>           self.site.application = app
>>>           sock = eventlet.connect(self.server_addr)
>>>           req_body = b'GET /tricksy HTTP/1.1\r\n'
>>>           body_len = str(len(req_body)).encode('ascii')
>>>
>>>           sock.sendall(b'PUT /1 HTTP/1.0\r\nHost:
>>> localhost\r\nConnection: keep-alive\r\n'
>>>                        b'Content-Length: ' + body_len + b'\r\n\r\n' +
>>> req_body)
>>>           result1 = read_http(sock)
>>>           self.assertEqual(b'first response', result1.body)
>>>           self.assertEqual(result1.headers_original.get('Connection'),
>>> 'keep-alive')
>>>
>>>           sock.sendall(b'PUT /2 HTTP/1.0\r\nHost:
>>> localhost\r\nConnection: keep-alive\r\n'
>>>                        b'Content-Length: ' + body_len + b'\r\nExpect:
>>> 100-continue\r\n\r\n')
>>>           # Client may have a short timeout waiting on that 100 Continue
>>>           # and basically immediately send its body
>>>           sock.sendall(req_body)
>>>           result2 = read_http(sock)
>>>           self.assertEqual(b'second response', result2.body)
>>>           self.assertEqual(result2.headers_original.get('Connection'),
>>> 'close')
>>>
>>>   >       sock.sendall(b'PUT /3 HTTP/1.0\r\nHost:
>>> localhost\r\nConnection: close\r\n\r\n')
>>>
>>> tests/wsgi_test.py:648:
>>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
>>> _ _ _ _
>>> eventlet/greenio/base.py:407: in sendall
>>>       tail = self.send(data, flags)
>>> eventlet/greenio/base.py:401: in send
>>>       return self._send_loop(self.fd.send, data, flags)
>>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
>>> _ _ _ _
>>>
>>> self = <eventlet.greenio.base.GreenSocket object at 0x7f5f2f73c9a0>
>>> send_method = <built-in method send of socket object at 0x7f5f2f73d520>
>>> data = b'PUT /3 HTTP/1.0\r\nHost: localhost\r\nConnection: 
>>> close\r\n\r\n'
>>> args = (0,), _timeout_exc = timeout('timed out'), eno = 32
>>>
>>>       def _send_loop(self, send_method, data, *args):
>>>           if self.act_non_blocking:
>>>               return send_method(data, *args)
>>>
>>>           _timeout_exc = socket_timeout('timed out')
>>>           while True:
>>>               try:
>>>   >               return send_method(data, *args)
>>> E               BrokenPipeError: [Errno 32] Broken pipe
>>>
>>> eventlet/greenio/base.py:388: BrokenPipeError
>>> ====================
>>>
>>> Reverting this revert on the top of 5.19 solves the issue.
>>>
>>> Any ideas?
>>
>> Interesting. This revert should return the kernel back to the delayed
>> ACK behavior it had for many years before May 2019 and Linux 5.1,
>> which contains the commit it is reverting:
>>
>>    4a41f453bedfd tcp: change pingpong threshold to 3
>>
>> It sounds like perhaps this test you mention has an implicit
>> dependence on the timing of delayed ACKs.
>>
>> A few questions:
> 
> Dunno. I am only an openSUSE kernel maintainer and this popped out at 
> me. Feel free to dig to eventlet's sources on your own :P.

Any updates on this or should I send a revert directly?

The "before() &&" part of the patch makes the difference. That is this diff:
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -172,9 +172,17 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
          * and it is a reply for ato after last received packet,
          * increase pingpong count.
          */
-       if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
-           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
+       pr_info("%s: sk=%p (%llx:%x) now=%u lsndtime=%u lrcvtime=%u 
ping=%u\n",
+                       __func__, sk, sk->sk_addrpair, sk->sk_portpair, now,
+                       tp->lsndtime, icsk->icsk_ack.lrcvtime,
+                       inet_csk(sk)->icsk_ack.pingpong);
+       if (//before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
+           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato) {
                 inet_csk_inc_pingpong_cnt(sk);
+               pr_info("\tINC ping=%u before=%u\n",
+                               inet_csk(sk)->icsk_ack.pingpong,
+                               before(tp->lsndtime, 
icsk->icsk_ack.lrcvtime));
+       }

         tp->lsndtime = now;
  }

makes it work again, and outputs this:

 > TCP: tcp_event_data_sent: sk=00000000fd67cf8d 
(100007f0100007f:e858b18b) now=4294902140 lsndtime=4294902140 
lrcvtime=4294902140 ping=0
 > TCP: tcp_event_data_sent: sk=00000000a4becf82 
(100007f0100007f:8bb158e8) now=4294902143 lsndtime=4294902140 
lrcvtime=4294902142 ping=0
 > TCP:     INC ping=1 before=1
 > TCP: tcp_event_data_sent: sk=00000000fd67cf8d 
(100007f0100007f:e858b18b) now=4294902145 lsndtime=4294902140 
lrcvtime=4294902144 ping=0
 > TCP:     INC ping=1 before=1
 > TCP: tcp_event_data_sent: sk=00000000fd67cf8d 
(100007f0100007f:e858b18b) now=4294902147 lsndtime=4294902145 
lrcvtime=4294902144 ping=1
 > TCP:     INC ping=2 before=0

IMO, this "before=0" is the "source" of the problem. But I have no idea 
what this means at all...

 > TCP: tcp_event_data_sent: sk=00000000a4becf82 
(100007f0100007f:8bb158e8) now=4294902149 lsndtime=4294902143 
lrcvtime=4294902148 ping=1
 > TCP:     INC ping=2 before=1
 > TCP: tcp_event_data_sent: sk=00000000fd67cf8d 
(100007f0100007f:e858b18b) now=4294902151 lsndtime=4294902147 
lrcvtime=4294902150 ping=3
 > TCP:     INC ping=4 before=1
 > TCP: tcp_event_data_sent: sk=00000000c7a417e9 
(100007f0100007f:e85ab18b) now=4294902153 lsndtime=4294902153 
lrcvtime=4294902153 ping=0
 > TCP: tcp_event_data_sent: sk=000000008681183e 
(100007f0100007f:8bb15ae8) now=4294902155 lsndtime=4294902153 
lrcvtime=4294902154 ping=0
 > TCP:     INC ping=1 before=1



>> (1) What are the timeout values in this test? If there is some
>> implicit or explicit timeout value less than the typical Linux TCP
>> 40ms delayed ACK timer value then this could be the problem. If you
>> make sure all timeouts are at least, say, 300ms then this should
>> remove dependencies on delayed ACK behavior (and make the test more
>> portable).
>>
>> (2) Does this test use the TCP_NODELAY socket option to disable
>> Nagle's algorithm? Presumably it should, given that it's a network app
>> that cares about latency. Omitting the TCP_NODELAY socket option can
>> cause request/response traffic to depend on delayed ACK behavior.
>>
>> (3) If (1) and (2) do not fix the test, would you be able to provide
>> binary .pcap traces of the behavior with the test (a) passing and (b)
>> failing? For example:
>>     sudo tcpdump -i any -w /tmp/trace.pcap -s 100 port 80 &
>>     # run test
>>     killall tcpdump
>>
>> thanks,
>> neal
> 
> 

thanks,
-- 
js
suse labs

