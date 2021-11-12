Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E44544EE34
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 21:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbhKLU6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 15:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbhKLU6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 15:58:54 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACE3C061766;
        Fri, 12 Nov 2021 12:56:02 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso7983586wms.3;
        Fri, 12 Nov 2021 12:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DLDIyZOAu1EjspejLSbzF9V6IFRoP+UqGIouXcUX5Kk=;
        b=Df+FwvFoTNgGnELyOswXZ6lKA+b5xT6JguRofaygpzFwl3by4ATQvfvZAsI8WbYkDT
         naaB1rMsIN2LqGYWnBUjuqbvSI44zTWkLfq32kfm0YvD/lw1AxwaiOA/lSusUKPETRnO
         UELFzZnHonqHN6t41y99/rqslLwxPQH5BAS++ZYBU1K5+dGG3H+cxxmpSX3z4Qcws/+9
         0+4zjetEQgdUluo4MnPQIQCiDd60k8rjNuZi1rM0NF8kecNkRGbuLs1P7r74g6G4iai+
         sO5mGmEYvZwzhKYs5zd7Y7Wz+ZsVI/AQh7THX8ifQhvbL2DYsScMbrESZ1Ec5Yva03i5
         PHAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DLDIyZOAu1EjspejLSbzF9V6IFRoP+UqGIouXcUX5Kk=;
        b=kxk4OCKplBSIYSXXE9r2KRcT7VfyZanWhFKUC6oskh+HBWtbkbpQSRNUR3vTeBj1Lv
         47eZ95FRR3zbrkreYfMtb4eTJ/uEkqJS8yzpYlMO2gdPWRJBmVOB5xlxJEob2JoX8+51
         7Kku3ws5Db+cLLI/lhy403js8pOuMZxP9LeA35MxpYgvM8Qvv08A/5tUoxZowm7tuPUy
         0m0v0w7+f9D7TQIxGb5C1U7KB7INNrPumgZ12FmRyoenxdJBQbvNf/J/GhlO/W3s6t98
         n41A3BOPozxcXnuaZxRIxkRdBCWLaAL3ZpXEt8Myd/SmIMb9USU+KrhzDNH0BT6b+kb6
         wYjA==
X-Gm-Message-State: AOAM531Qbn+zneOjTjZdymo8hT5sIQ3cNrfENg5uwp7gQS7M8ewchfRh
        iMLdvyKvW5c9i2khcpucshU=
X-Google-Smtp-Source: ABdhPJyMGW8UQcJCQe7uq4RaLIuOok7HfYmjrsiQiDwCF5U35iuotPAX79ckcMMvEGe1tBnzvGdY9w==
X-Received: by 2002:a1c:43c1:: with SMTP id q184mr37795999wma.153.1636750561394;
        Fri, 12 Nov 2021 12:56:01 -0800 (PST)
Received: from [10.168.10.170] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id u6sm6533113wmc.29.2021.11.12.12.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 12:56:00 -0800 (PST)
Sender: Alejandro Colomar <alx.mailinglists@gmail.com>
Message-ID: <de1c353c-2b3c-ff15-a8e7-dd8db8672c93@gmail.com>
Date:   Fri, 12 Nov 2021 21:55:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [patch v3] tcp.7: Add description for TCP_FASTOPEN and
 TCP_FASTOPEN_CONNECT options
Content-Language: en-US
To:     Wei Wang <weiwan@google.com>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "G. Branden Robinson" <g.branden.robinson@gmail.com>
References: <20210924235456.2413081-1-weiwan@google.com>
 <CAEA6p_CSbFFiEUQKy_n5dBd-oBWLq1L0CZYjECqBfjjkeQoSdg@mail.gmail.com>
 <6c5ac9d3-9e9a-12aa-7dc8-d89553790e7b@gmail.com>
 <CAEA6p_CXGaboJaO+LCM=c_tnf2P5oZZyXwJn1ybQDakWp+b=8g@mail.gmail.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <CAEA6p_CXGaboJaO+LCM=c_tnf2P5oZZyXwJn1ybQDakWp+b=8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wei,

On 11/5/21 18:19, Wei Wang wrote:
> On Fri, Oct 15, 2021 at 3:12 PM Alejandro Colomar (man-pages)
> <alx.manpages@gmail.com> wrote:
>>
>> Hi Wei,
>>
>> On 10/15/21 6:08 PM, Wei Wang wrote:
>>> On Fri, Sep 24, 2021 at 4:54 PM Wei Wang <weiwan@google.com> wrote:
>>>>
>>>> TCP_FASTOPEN socket option was added by:
>>>> commit 8336886f786fdacbc19b719c1f7ea91eb70706d4
>>>> TCP_FASTOPEN_CONNECT socket option was added by the following patch
>>>> series:
>>>> commit 065263f40f0972d5f1cd294bb0242bd5aa5f06b2
>>>> commit 25776aa943401662617437841b3d3ea4693ee98a
>>>> commit 19f6d3f3c8422d65b5e3d2162e30ef07c6e21ea2
>>>> commit 3979ad7e82dfe3fb94a51c3915e64ec64afa45c3
>>>> Add detailed description for these 2 options.
>>>> Also add descriptions for /proc entry tcp_fastopen and tcp_fastopen_key.
>>>>
>>>> Signed-off-by: Wei Wang <weiwan@google.com>

Sorry for the delay.
I have applied it now.
I also applied some minor changes on top of your patch
(see below).

Thanks!
Alex


---

     tcp.7: Minor tweaks to Wei's patch

     - wsfix
     - Boldface literals (see groff_man(7)).
     - Replace '\ ' by \~, per Branden's advise.
     - Use phrasal semantic newlines.
     - Put '...' in a C comment, to avoid interfering with groff.
       It has the side effect that the code example is pure C now.
     - Remove incorrect trailing '.IP'.

     Cc: Wei Wang <weiwan@google.com>
     Signed-off-by: Alejandro Colomar <alx.manpages@gmail.com>

diff --git a/man7/tcp.7 b/man7/tcp.7
index 264e3ccc4..69d85c05a 100644
--- a/man7/tcp.7
+++ b/man7/tcp.7
@@ -423,26 +423,31 @@ option.
  .\" Since 2.4.0-test7
  Enable RFC\ 2883 TCP Duplicate SACK support.
  .TP
-.IR tcp_fastopen  " (Bitmask; default: 0x1; since Linux 3.7)"
-Enables RFC\ 7413 Fast Open support.
+.IR tcp_fastopen " (Bitmask; default: 0x1; since Linux 3.7)"
+Enables RFC\~7413 Fast Open support.
  The flag is used as a bitmap with the following values:
  .RS
-.IP 0x1
+.TP
+.B 0x1
  Enables client side Fast Open support
-.IP 0x2
+.TP
+.B 0x2
  Enables server side Fast Open support
-.IP 0x4
+.TP
+.B 0x4
  Allows client side to transmit data in SYN without Fast Open option
-.IP 0x200
+.TP
+.B 0x200
  Allows server side to accept SYN data without Fast Open option
-.IP 0x400
+.TP
+.B 0x400
  Enables Fast Open on all listeners without
  .B TCP_FASTOPEN
  socket option
  .RE
  .TP
  .IR tcp_fastopen_key " (since Linux 3.7)"
-Set server side RFC\ 7413 Fast Open key to generate Fast Open cookie
+Set server side RFC\~7413 Fast Open key to generate Fast Open cookie
  when server side Fast Open support is enabled.
  .TP
  .IR tcp_ecn " (Integer; default: see below; since Linux 2.4)"
@@ -1226,19 +1231,19 @@ This option should not be used in code intended 
to be
  portable.
  .TP
  .BR TCP_FASTOPEN " (since Linux 3.6)"
-This option enables Fast Open (RFC\ 7413) on the listener socket.
+This option enables Fast Open (RFC\~7413) on the listener socket.
  The value specifies the maximum length of pending SYNs
  (similar to the backlog argument in
  .BR listen (2)).
  Once enabled,
-the listener socket grants the TCP Fast Open cookie on incoming
-SYN with TCP Fast Open option.
+the listener socket grants the TCP Fast Open cookie
+on incoming SYN with TCP Fast Open option.
  .IP
  More importantly it accepts the data in SYN with a valid Fast Open cookie
  and responds SYN-ACK acknowledging both the data and the SYN sequence.
  .BR accept (2)
-returns a socket that is available for read and write when the handshake
-has not completed yet.
+returns a socket that is available for read and write
+when the handshake has not completed yet.
  Thus the data exchange can commence before the handshake completes.
  This option requires enabling the server-side support on sysctl
  .IR net.ipv4.tcp_fastopen
@@ -1252,18 +1257,18 @@ or
  below.
  .TP
  .BR TCP_FASTOPEN_CONNECT " (since Linux 4.11)"
-This option enables an alternative way to perform Fast Open on the active
-side (client).
+This option enables an alternative way to perform Fast Open
+on the active side (client).
  When this option is enabled,
  .BR connect (2)
-would behave differently depending on if a Fast Open cookie is available
-for the destination.
+would behave differently depending on
+if a Fast Open cookie is available for the destination.
  .IP
  If a cookie is not available (i.e. first contact to the destination),
  .BR connect (2)
  behaves as usual by sending a SYN immediately,
-except the SYN would include an empty Fast Open cookie option to solicit a
-cookie.
+except the SYN would include an empty Fast Open cookie option
+to solicit a cookie.
  .IP
  If a cookie is available,
  .BR connect (2)
@@ -1297,13 +1302,12 @@ without
  .BR write (2)
  will cause the blocking socket to be blocked forever.
  .IP
-The application should  either set
+The application should either set
  .B TCP_FASTOPEN_CONNECT
  socket option before
  .BR write (2)
  or
-.BR sendmsg (2)
-,
+.BR sendmsg (2),
  or call
  .BR write (2)
  or
@@ -1322,11 +1326,10 @@ setsockopt(s, IPPROTO_TCP, TCP_FASTOPEN_CONNECT, 
1, ...);
  connect(s);
  write(s); // write() should always follow connect() in order to 
trigger SYN to go out
  read(s)/write(s);
-...
+/* ... */
  close(s);
  .EE
  .in
-.IP
  .SS Sockets API
  TCP provides limited support for out-of-band data,
  in the form of (a single byte of) urgent data.
