Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2D58B630
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiHFOmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiHFOmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:42:02 -0400
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF75BE021;
        Sat,  6 Aug 2022 07:42:00 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id kb8so9531858ejc.4;
        Sat, 06 Aug 2022 07:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=CynnFjILFz1Z18pN2bwfL5YKDJlz/l/hjn8hr+WcG88=;
        b=ErhykQBDzZUOFTam6N7SwjWUB8xOYiSXT4LcvuLXMgQtj1JARZ4wkLKKh+whbOi+DR
         QHdGVknafdmiQxYH+ZPOabp4JgQJ4iOiWXNpYTpptZqNa8oeL0mCk20EwX6J1VyRNXB9
         2jekhoc2rP4oBiLz82X1u8cwC1pWm8VMWakEu0DbpB0zGoCw9x6SIMWkNkPBwqzlAfB1
         XjfYwKEkICGZiAXhay7KTR8M9DF5S9FfyzROVhNSvlyG20gFPwiqDfEtLVRhjTUhO6Wr
         YwrmA+AHyQo0ZKEZkCsoPlBPxqCV1eAUCgOHsnjI5G+XYQmjiQHhDKBezk9JljQB2oVQ
         eN9A==
X-Gm-Message-State: ACgBeo1LXsKsq3UgZE8v0MsrFovClHSfSepagUvxO+HHSm8jxT+fBsB/
        i261mRSZ4+A6FwQhv96z5zg=
X-Google-Smtp-Source: AA6agR5l+dmZTuQTqd9AteoSAgraTwI/2PbdcQgRsVdtfai+37mNAcRfkkAutUKbugAYtiygCz0JkA==
X-Received: by 2002:a17:906:9b92:b0:730:a237:40fe with SMTP id dd18-20020a1709069b9200b00730a23740femr8483225ejc.464.1659796919395;
        Sat, 06 Aug 2022 07:41:59 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906211100b0072af92fa086sm2782976ejt.32.2022.08.06.07.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Aug 2022 07:41:58 -0700 (PDT)
Message-ID: <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org>
Date:   Sat, 6 Aug 2022 16:41:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
Content-Language: en-US
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
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06. 08. 22, 13:24, Neal Cardwell wrote:
> On Sat, Aug 6, 2022 at 6:02 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>>
>> On 21. 07. 22, 22:44, Wei Wang wrote:
>>> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
>>>
>>> This to-be-reverted commit was meant to apply a stricter rule for the
>>> stack to enter pingpong mode. However, the condition used to check for
>>> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
>>> jiffy based and might be too coarse, which delays the stack entering
>>> pingpong mode.
>>> We revert this patch so that we no longer use the above condition to
>>> determine interactive session, and also reduce pingpong threshold to 1.
>>>
>>> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
>>> Reported-by: LemmyHuang <hlm3280@163.com>
>>> Suggested-by: Neal Cardwell <ncardwell@google.com>
>>> Signed-off-by: Wei Wang <weiwan@google.com>
>>
>>
>> This breaks python-eventlet [1] (and was backported to stable trees):
>> ________________ TestHttpd.test_018b_http_10_keepalive_framing
>> _________________
>>
>> self = <tests.wsgi_test.TestHttpd
>> testMethod=test_018b_http_10_keepalive_framing>
>>
>>       def test_018b_http_10_keepalive_framing(self):
>>           # verify that if an http/1.0 client sends connection: keep-alive
>>           # that we don't mangle the request framing if the app doesn't
>> read the request
>>           def app(environ, start_response):
>>               resp_body = {
>>                   '/1': b'first response',
>>                   '/2': b'second response',
>>                   '/3': b'third response',
>>               }.get(environ['PATH_INFO'])
>>               if resp_body is None:
>>                   resp_body = 'Unexpected path: ' + environ['PATH_INFO']
>>                   if six.PY3:
>>                       resp_body = resp_body.encode('latin1')
>>               # Never look at wsgi.input!
>>               start_response('200 OK', [('Content-type', 'text/plain')])
>>               return [resp_body]
>>
>>           self.site.application = app
>>           sock = eventlet.connect(self.server_addr)
>>           req_body = b'GET /tricksy HTTP/1.1\r\n'
>>           body_len = str(len(req_body)).encode('ascii')
>>
>>           sock.sendall(b'PUT /1 HTTP/1.0\r\nHost:
>> localhost\r\nConnection: keep-alive\r\n'
>>                        b'Content-Length: ' + body_len + b'\r\n\r\n' +
>> req_body)
>>           result1 = read_http(sock)
>>           self.assertEqual(b'first response', result1.body)
>>           self.assertEqual(result1.headers_original.get('Connection'),
>> 'keep-alive')
>>
>>           sock.sendall(b'PUT /2 HTTP/1.0\r\nHost:
>> localhost\r\nConnection: keep-alive\r\n'
>>                        b'Content-Length: ' + body_len + b'\r\nExpect:
>> 100-continue\r\n\r\n')
>>           # Client may have a short timeout waiting on that 100 Continue
>>           # and basically immediately send its body
>>           sock.sendall(req_body)
>>           result2 = read_http(sock)
>>           self.assertEqual(b'second response', result2.body)
>>           self.assertEqual(result2.headers_original.get('Connection'),
>> 'close')
>>
>>   >       sock.sendall(b'PUT /3 HTTP/1.0\r\nHost:
>> localhost\r\nConnection: close\r\n\r\n')
>>
>> tests/wsgi_test.py:648:
>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
>> _ _ _ _
>> eventlet/greenio/base.py:407: in sendall
>>       tail = self.send(data, flags)
>> eventlet/greenio/base.py:401: in send
>>       return self._send_loop(self.fd.send, data, flags)
>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
>> _ _ _ _
>>
>> self = <eventlet.greenio.base.GreenSocket object at 0x7f5f2f73c9a0>
>> send_method = <built-in method send of socket object at 0x7f5f2f73d520>
>> data = b'PUT /3 HTTP/1.0\r\nHost: localhost\r\nConnection: close\r\n\r\n'
>> args = (0,), _timeout_exc = timeout('timed out'), eno = 32
>>
>>       def _send_loop(self, send_method, data, *args):
>>           if self.act_non_blocking:
>>               return send_method(data, *args)
>>
>>           _timeout_exc = socket_timeout('timed out')
>>           while True:
>>               try:
>>   >               return send_method(data, *args)
>> E               BrokenPipeError: [Errno 32] Broken pipe
>>
>> eventlet/greenio/base.py:388: BrokenPipeError
>> ====================
>>
>> Reverting this revert on the top of 5.19 solves the issue.
>>
>> Any ideas?
> 
> Interesting. This revert should return the kernel back to the delayed
> ACK behavior it had for many years before May 2019 and Linux 5.1,
> which contains the commit it is reverting:
> 
>    4a41f453bedfd tcp: change pingpong threshold to 3
> 
> It sounds like perhaps this test you mention has an implicit
> dependence on the timing of delayed ACKs.
> 
> A few questions:

Dunno. I am only an openSUSE kernel maintainer and this popped out at 
me. Feel free to dig to eventlet's sources on your own :P.

> (1) What are the timeout values in this test? If there is some
> implicit or explicit timeout value less than the typical Linux TCP
> 40ms delayed ACK timer value then this could be the problem. If you
> make sure all timeouts are at least, say, 300ms then this should
> remove dependencies on delayed ACK behavior (and make the test more
> portable).
> 
> (2) Does this test use the TCP_NODELAY socket option to disable
> Nagle's algorithm? Presumably it should, given that it's a network app
> that cares about latency. Omitting the TCP_NODELAY socket option can
> cause request/response traffic to depend on delayed ACK behavior.
> 
> (3) If (1) and (2) do not fix the test, would you be able to provide
> binary .pcap traces of the behavior with the test (a) passing and (b)
> failing? For example:
>     sudo tcpdump -i any -w /tmp/trace.pcap -s 100 port 80 &
>     # run test
>     killall tcpdump
> 
> thanks,
> neal


-- 
js
