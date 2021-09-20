Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE84412A5A
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhIUBkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbhIUBj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:39:28 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D225C03D77A;
        Mon, 20 Sep 2021 12:50:35 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x6so32864361wrv.13;
        Mon, 20 Sep 2021 12:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LxHxir7CeXhCjYPMo50dDuHVIq/CDVZMDJgWUgKXIFU=;
        b=jS9FD5PqjDLZoazA/pNEBCROErVg8/M3v7ZYSHuGYidHX0LSBl/pFo/8A4m6YgL/d2
         AYltolkYPFBpkiw4NsVvpp+33u7JJKPXTLqs4KtQUYv4c47FPfDcqtf6PCCsmHe+ut+9
         BeqxqXdX3fBwJdnwBHzlutoU//Pxaz4LV1lKtkKVwrI8QeZpsEVWlVbNTXoeZVTkAlYx
         +4XSmAfB3pQNlfJl8QRE7wyuhlrNUPD6HGK7xjWNUV2pg3Gr+MVfoGPjzmRezDfs3gfi
         ShR+S9dEcqTXS0RV2VGZ7MxpsuxKhfQiwN8/fugmt9hRoMijU8fFL9gd3u97yTs7ihnh
         cY8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LxHxir7CeXhCjYPMo50dDuHVIq/CDVZMDJgWUgKXIFU=;
        b=3vLk8/8xUW3Ol5SDA90mkV0rc1i41dboNAgZHE5RUR73hT+47o2a9329/ZwFc50i/5
         6A1VkfaZmJvD+5vsWg8Vtm7Ka/JM6LGvte3ZYKMOcgUqh16Ay//Yj7MBxFopTx91+Zhs
         WyNP3i5Y/Ml7rhE/DC+13p+cAeTDf9yhepUC63sPeiHpTsU2Yb7kge+y7CYrJo9wOevD
         zMAxzXLdFP/XFkR69Z/BRDyspEMn5+YbCPk3uFrIlQXFNBdAmABZauni8bBmDSzr5o39
         Nz0BVb7Ky+EPYSXdX3x2iI35QDE1WCdv5HgKIQiRN7KFiaVjDOZspYF3BbH6m09iyEUD
         PgrQ==
X-Gm-Message-State: AOAM530lWq/eh0INPTwekrpL98LcrYIDvxeDlfnufFcn/CntgPz8fW9h
        41iVyzlThCg1/YkXgefSY1a1oEtuhwg=
X-Google-Smtp-Source: ABdhPJyB2h4Vway07KgS5uYjN3X7N50ZRqjRL75LP1zwXuJSW5K92Kr4uk3xDgfdr4BvRWR/D3yBLg==
X-Received: by 2002:a1c:1fd3:: with SMTP id f202mr797637wmf.44.1632167434048;
        Mon, 20 Sep 2021 12:50:34 -0700 (PDT)
Received: from [10.8.0.102] ([195.53.121.100])
        by smtp.gmail.com with ESMTPSA id t23sm17790995wrb.71.2021.09.20.12.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 12:50:33 -0700 (PDT)
Subject: Re: [patch v2] tcp.7: Add description for TCP_FASTOPEN and
 TCP_FASTOPEN_CONNECT options
To:     Wei Wang <weiwan@google.com>
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org
References: <20210917041702.167622-1-weiwan@google.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <c0617af0-fc29-5ac6-deb0-d0da3fcfc99d@gmail.com>
Date:   Mon, 20 Sep 2021 21:50:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917041702.167622-1-weiwan@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Wei,

On 9/17/21 6:17 AM, Wei Wang wrote:
> TCP_FASTOPEN socket option was added by:
> commit 8336886f786fdacbc19b719c1f7ea91eb70706d4
> TCP_FASTOPEN_CONNECT socket option was added by the following patch
> series:
> commit 065263f40f0972d5f1cd294bb0242bd5aa5f06b2
> commit 25776aa943401662617437841b3d3ea4693ee98a
> commit 19f6d3f3c8422d65b5e3d2162e30ef07c6e21ea2
> commit 3979ad7e82dfe3fb94a51c3915e64ec64afa45c3
> Add detailed description for these 2 options.
> Also add descriptions for /proc entry tcp_fastopen and tcp_fastopen_key.
> 
> Signed-off-by: Wei Wang <weiwan@google.com>
> Reviewed-by: Yuchung Cheng <ycheng@google.com>

Thanks for the patch (and the review, Yuchung)!

Please see some comments below.

Cheers,

Alex

> ---
> Change in v2: corrected some format issues
> 
>   man7/tcp.7 | 110 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 110 insertions(+)
> 
> diff --git a/man7/tcp.7 b/man7/tcp.7
> index 0a7c61a37..5a6fa7f50 100644
> --- a/man7/tcp.7
> +++ b/man7/tcp.7
> @@ -423,6 +423,28 @@ option.
>   .\" Since 2.4.0-test7
>   Enable RFC\ 2883 TCP Duplicate SACK support.
>   .TP
> +.IR tcp_fastopen  " (Bitmask; default: 0x1; since Linux 3.7)"
> +Enables RFC\ 7413 Fast Open support.
> +The flag is used as a bitmap with the following values:
> +.RS
> +.IP 0x1
> +Enables client side Fast Open support
> +.IP 0x2
> +Enables server side Fast Open support
> +.IP 0x4
> +Allows client side to transmit data in SYN without Fast Open option
> +.IP 0x200
> +Allows server side to accept SYN data without Fast Open option
> +.IP 0x400
> +Enables Fast Open on all listeners without
> +.B TCP_FASTOPEN
> +socket option
> +.RE
> +.TP
> +.IR tcp_fastopen_key " (since Linux 3.7)"
> +Set server side RFC\ 7413 Fast Open key to generate Fast Open cookie
> +when server side Fast Open support is enabled.
> +.TP
>   .IR tcp_ecn " (Integer; default: see below; since Linux 2.4)"
>   .\" Since 2.4.0-test7
>   Enable RFC\ 3168 Explicit Congestion Notification.
> @@ -1202,6 +1224,94 @@ Bound the size of the advertised window to this value.
>   The kernel imposes a minimum size of SOCK_MIN_RCVBUF/2.
>   This option should not be used in code intended to be
>   portable.
> +.TP
> +.BR TCP_FASTOPEN " (since Linux 3.6)"
> +This option enables Fast Open (RFC\ 7413) on the listener socket.
> +The value specifies the maximum length of pending SYNs
> +(similar to the backlog argument in
> +.BR listen (2)).
> +Once enabled,
> +the listener socket grants the TCP Fast Open cookie on incoming
> +SYN with TCP Fast Open option.
> +.IP
> +More importantly it accepts the data in SYN with a valid Fast Open cookie
> +and responds SYN-ACK acknowledging both the data and the SYN sequence.
> +.BR accept (2)
> +returns a socket that is available for read and write when the handshake
> +has not completed yet.
> +Thus the data exchange can commence before the handshake completes.
> +This option requires enabling the server-side support on sysctl
> +.IR net.ipv4.tcp_fastopen
> +(see above).
> +For TCP Fast Open client-side support,
> +see
> +.BR send (2)
> +.B MSG_FASTOPEN
> +or
> +.B TCP_FASTOPEN_CONNECT
> +below.
> +.TP
> +.BR TCP_FASTOPEN_CONNECT " (since Linux 4.11)"
> +This option enables an alternative way to perform Fast Open on the active
> +side (client).
> +When this option is enabled,
> +.BR connect (2)
> +would behave differently depending if a Fast Open cookie is available for
> +the destination.
> +.IP
> +If a cookie is not available (i.e. first contact to the destination),
> +.BR connect (2)
> +behaves as usual by sending a SYN immediately,
> +except the SYN would include an empty Fast Open cookie option to solicit a
> +cookie.
> +.IP
> +If a cookie is available,
> +.BR connect (2)
> +would return 0 immediately but the SYN transmission is defered.
> +A subsequent
> +.BR write (2)
> +or
> +.BR sendmsg (2)
> +would trigger a SYN with data plus cookie in the Fast Open option.
> +In other words,
> +the actual connect operation is deferred until data is supplied.
> +.IP
> +.B Note:
> +While this option is designed for convenience,
> +enabling it does change the behaviors and might set new
> +.I errnos

typo?

errno values?

> +of socket calls.

The above is not very clear to me.

> +With cookie present,
> +.BR write (2)
> +/

Does this mean an "or"?  If so, prefer the "or".

> +.BR sendmsg (2)
> +must be called right after
> +.BR connect (2)
> +in order to send out SYN+data to complete 3WHS and establish connection.
> +Calling
> +.BR read (2)
> +right after
> +.BR connect (2)
> +without
> +.BR write (2)
> +will cause the blocking socket to be blocked forever.


> +The application should use either
> +.B TCP_FASTOPEN_CONNECT
> +or
> +.BR send (2)

This is not clear to me.  So TCP_FASTOPEN_CONNECT can use write(2) and 
sendmsg(2) (mentioned above), and TCP_FASTOPEN can only use send(2)?  Or 
what did you mean?

> +with
> +.B MSG_FASTOPEN ,
> +instead of both on the same connection.

 From "The application ...":
Does this have relation with the text just above it?  It appears to me 
to be a more generic statement that both options shouldn't be mixed, so 
maybe a new paragraph is more appropriate.

> +.IP
> +Here is the typical call flow with this new option:
> +  s = socket();
> +  setsockopt(s, IPPROTO_TCP, TCP_FASTOPEN_CONNECT, 1, ...);
> +  connect(s);
> +  write(s); // write() should always follow connect() in order to
> +            // trigger SYN to go out
> +  read(s)/write(s);
> +  ... > +  close(s);

See man-pages(7):

    Indentation of structure definitions, shell session  logs,  and
        so on
        When  structure  definitions, shell session logs, and so on
        are included in running  text,  indent  them  by  4  spaces
        (i.e.,  a  block  enclosed by .in +4n and .in), format them
        using the .EX and EE macros, and surround them  with  suit‐
        able paragraph markers (either .PP or .IP).  For example:

                .PP
                .in +4n
                .EX
                int
                main(int argc, char *argv[])
                {
                    return 0;
                }
                .EE
                .in
                .PP


>   .SS Sockets API
>   TCP provides limited support for out-of-band data,
>   in the form of (a single byte of) urgent data.
> 


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
