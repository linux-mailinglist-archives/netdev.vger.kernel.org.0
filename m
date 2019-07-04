Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366395FDC9
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfGDU3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:29:13 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46732 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfGDU3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:29:13 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so14822101iol.13
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 13:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+DmhdBUVDfZDKio5ssgpD7eIo7Wvt6FDp3e2/ElxsF8=;
        b=P3Zey+fXQABAWTDwMF343sY6ljT4fNTJsF3YgFJfA7VnQjR5aWMzIgHezeSy7VsaGW
         ZuST5e00IpwKpBhUBW8Cbb+2qF6V1zOhtcDZ137/Ee37Mmoj1Z/V9KeFXGPYIz25L8sc
         0RB5Jv9jQr5LmAfyA7+ddLKeMYvxDEv7P0V5dR3oYzqWZ2VYkdYajLINYm2yrtXPLW7E
         7UM/pyEXdaQsjhR00At5ap1C0Vn/KiucYmN637wV80pesEkw67aepEKel75LrqU0hCW7
         CJIdaZQjaZJUdBkZc6ivBOkxShQ9Yjm9fMYtlLe3aJxM5K79g1xj+/yEYqUguGf41PNU
         SbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+DmhdBUVDfZDKio5ssgpD7eIo7Wvt6FDp3e2/ElxsF8=;
        b=VV7Vm0wfpNK8G3GUGGFNdovCDPlDXW8OYfLh75Fhw90/fw1yT8PBj2ki2UlZt5/HhV
         NKCizyvE/9nRZzq1owp+CRzhwa0OgJJNjGDpHCOdru25bO2I6mJ63Y5ISbsrKZmnabi1
         yc6yEUZ7VpXd5qmXPzthqufl19RCjUdqDm2Ecq5DywKWQLxfniPoXxjDc2OhbeOmwQmF
         v3Sjy+4v6rn96ITAnfqJzEQM8viBgLmsYFG46/2TO4qjGnCF7gv7AseSVIL6QIum7UpR
         7RaUBlixox+wrtTBQhG2TloMqQoYSHB/qpLw6k7dLYrCs351X639TapqsMN5SCzEE5Kc
         wHmA==
X-Gm-Message-State: APjAAAWWJwndTytfNYX6fSmoS06imuedwA8PBXnC5aYNWtgRW1hqwrfZ
        KSvzrZbAzbBOOX4lTJ5lKKYFwA==
X-Google-Smtp-Source: APXvYqzBiF/vIzfjkaHKn+SFaWXW++ugkFP7MsR6t9MOuhTSemx6ciBXmtf31CfrrNBVTIA465Rxug==
X-Received: by 2002:a5e:9304:: with SMTP id k4mr260938iom.206.1562272152384;
        Thu, 04 Jul 2019 13:29:12 -0700 (PDT)
Received: from x220t ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id a2sm5636065iod.57.2019.07.04.13.29.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Jul 2019 13:29:12 -0700 (PDT)
Date:   Thu, 4 Jul 2019 16:29:09 -0400
From:   Alexander Aring <aring@mojatatu.com>
To:     Lucas Bates <lucasb@mojatatu.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, mleitner@redhat.com,
        vladbu@mellanox.com, dcaratti@redhat.com, kernel@mojatatu.com
Subject: Re: [PATCH v2 net-next 3/3] tc-testing: introduce scapyPlugin for
 basic traffic
Message-ID: <20190704202909.gmggf3agxjgvyjsj@x220t>
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
 <1562201102-4332-4-git-send-email-lucasb@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1562201102-4332-4-git-send-email-lucasb@mojatatu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jul 03, 2019 at 08:45:02PM -0400, Lucas Bates wrote:
> The scapyPlugin allows for simple traffic generation in tdc to
> test various tc features. It was tested with scapy v2.4.2, but
> should work with any successive version.
> 
> In order to use the plugin's functionality, scapy must be
> installed. This can be done with:
>    pip3 install scapy
> 
> or to install 2.4.2:
>    pip3 install scapy==2.4.2
> 
> If the plugin is unable to import the scapy module, it will
> terminate the tdc run.
> 
> The plugin makes use of a new key in the test case data, 'scapy'.
> This block contains three other elements: 'iface', 'count', and
> 'packet':
> 
>         "scapy": {
>             "iface": "$DEV0",
>             "count": 1,
>             "packet": "Ether(type=0x800)/IP(src='16.61.16.61')/ICMP()"
>         },
> 
> * iface is the name of the device on the host machine from which
>   the packet(s) will be sent. Values contained within tdc_config.py's
>   NAMES dict can be used here - this is useful if paired with
>   nsPlugin
> * count is the number of copies of this packet to be sent
> * packet is a string detailing the different layers of the packet
>   to be sent. If a property isn't explicitly set, scapy will set
>   default values for you.
> 
> Layers in the packet info are separated by slashes. For info about
> common TCP and IP properties, see:
> https://blogs.sans.org/pen-testing/files/2016/04/ScapyCheatSheet_v0.2.pdf
> 
> Caution is advised when running tests using the scapy functionality,
> since the plugin blindly sends the packet as defined in the test case
> data.
> 
> See creating-testcases/scapy-example.json for sample test cases;
> the first test is intended to pass while the second is intended to
> fail. Consider using the matchJSON functionality for verification
> when using scapy.
> 

Is there a way to introduce thrid party scapy level descriptions which
are not upstream yet?

- Alex
