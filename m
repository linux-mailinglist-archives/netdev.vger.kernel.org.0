Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A6419AE6F
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 17:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733084AbgDAPED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 11:04:03 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33117 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732929AbgDAPEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 11:04:02 -0400
Received: by mail-lf1-f67.google.com with SMTP id x200so13588627lff.0
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 08:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:autocrypt:message-id:disposition-notification-to
         :date:mime-version:content-language:content-transfer-encoding;
        bh=0ol2jlivNIMi14es5KE78b/s+y98PcNkjD8b/BxRvI0=;
        b=nFmhTfIY1g32VB0Ek4uzZdPE5oM4j81zfd3e7gYLsacBiLjRiHeNkeyqeTwgzHJzJV
         R28du15GKRMlYehvPqJzwh1w8ZO29gqv01VF5fQOPUVITE2t0Lhxo1ggjpf5hIuQmJzD
         N/TflJwbSCdbbK4ihonufK/yi3GzjmlirylLOhTaoadCf5LjGtjIrVFZSpJfzZKeSKes
         V5+DAhJsqbCWjwsEh5tpG+Jp7/cBmDTI/G1+uNJxfIxkqzijaqJEDVXKWuLkLO0Xj67e
         TlIFYsUahicy8eAm2JEsFPk8LUPX5I9Wk0Uuaqt0d8yYZUAaQKgiPdAcctQGglQqf/rS
         3U7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:autocrypt:message-id
         :disposition-notification-to:date:mime-version:content-language
         :content-transfer-encoding;
        bh=0ol2jlivNIMi14es5KE78b/s+y98PcNkjD8b/BxRvI0=;
        b=oYd/Q1A44XogI3/qk6MgGE6MnIq/CqbG9J0emOGGm6tZk7CV34RC7Bzz1M/ptZ9jGu
         UUystxWmd7jjgyphO0U26mMDnv1aZYzM/+cbNuQabeKiGkuAusQw346+olwtB+YKRDT3
         ALy5j7Xyg/fR76b/Bab8qkURTcAFXoqFcnVpjrdOWdLgTdHBQ7+2wk9WjnsmJT17pihW
         Wxv3U56WJzcu+19TdkRYHmGhOpF5QbgB6kq2MwFAIXsQppE9jy31KAjh2tTtwBPiijGf
         Baa6eYNF2wupL6tWLW+3BGd5wVkyZvYQlrQUrhWkEnmJ7J+bQwWeD/o4NyEYmrAyroZe
         rfOA==
X-Gm-Message-State: AGi0PuY1o8dl9lvH6+7Nx57KGaZO0MX8YWRByzTLLAf4hnheWLHGBszg
        h//YGkrSUpsTheV7EOowZERO6JAk
X-Google-Smtp-Source: APiQypKb9cgAZCFsTusJ0/NUG0dNWjlv51q7qnQZeVnmXGLdLN/DlfL4MdGTAJlYTon0B1C9Sz5kTw==
X-Received: by 2002:a05:6512:6c4:: with SMTP id u4mr15231726lff.89.1585753439684;
        Wed, 01 Apr 2020 08:03:59 -0700 (PDT)
Received: from localhost (public-gprs252482.centertel.pl. [31.60.133.131])
        by smtp.gmail.com with ESMTPSA id u7sm1790208lfb.84.2020.04.01.08.03.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 08:03:59 -0700 (PDT)
To:     netdev@vger.kernel.org
From:   Mikhail Morfikov <morfikov@gmail.com>
Subject: Creating a bonding interface via the ip tool gives it the wrong MAC
 address
Autocrypt: addr=morfikov@gmail.com; keydata=
 mDMEXRaE+hYJKwYBBAHaRw8BAQdADVtvGNnC7y4y14i2IuxupgValXBb5YBbzeymUVfQEQu0
 Lk1pa2hhaWwgTW9yZmlrb3YgKE1vcmZpaykgPG1vcmZpa292QGdtYWlsLmNvbT6IlgQTFgoA
 PgIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBHVmE1jF+1cCeRanATLZy2NHlsyhBQJe
 Pv2fBQkDCawlAAoJEDLZy2NHlsyhtRoA/jWpJePkdf/X3ZweFGQD7EcmYa8Mc8b85InzvuDP
 czZrAQDfjICfUaZUjwPAKu9ZZrUPgo7WOJJAeVtqm6YK3gYUCLg4BF0WhPoSCisGAQQBl1UB
 BQEBB0DW89pZH+DofYPMWqLrOMQEKoS/ps6D43qVqEIS6EtzbgMBCAeIfgQYFgoAJgIbDBYh
 BHVmE1jF+1cCeRanATLZy2NHlsyhBQJePv4KBQkDCayQAAoJEDLZy2NHlsyhkhsBAKF0oQnM
 hczFQ4+zd8yf5y2HkIHo0JVdBIX4E+HMm425AQDlZNnOWQJ8qNeORyoMacN3s4dzwSzQ5HWy
 tOy2ebBQAg==
Message-ID: <a43adea0-8885-2bda-c931-5b8bf06e3a70@gmail.com>
Date:   Wed, 1 Apr 2020 17:03:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple months ago I opened an issue on the Debian Bug Tracker[1] concerning
some weird network behavior, in which bonding interface was involved. Basically, 
what I wanted to achieve was to have two interfaces (eth0 and wlan0) of my 
laptop in the *active-backup* mode, and in order to make this work, the 
*fail_over_mac* has to be set to *none*. Then the two interfaces (and also the 
bond0 interface) should have the same MAC address, which is set based on the 
interface specified by the *primary* parameter (in this case eth0). 

This was working well in the past, but it stopped for some reason. When the 
bond0 interface is being set up via the /etc/network/interfaces file, it gets 
wrong MAC address, and it's always the same MAC (ca:16:91:ae:9a:ba).  

I didn't really know where the problem was (it looks like no one knows so far), 
but I recently moved from ifupdown to systemd-networkd, and I noticed that the 
issue went away, at least in the default config. But in my case, I had to 
create the bonding interface during the initramfs/initrd phase using the *ip* 
tool (the regular one, and not the one from busybox). And the problem came back, 
but in this case I couldn't really fix it by just restarting the network 
connection.

So I created manually the bond0 interface using the *ip* tool in the following 
way to check what will happen:

ip link add name bond0 type bond mode active-backup \
  miimon 200 \
  downdelay 400 \
  updelay 400 \
  primary eth0 \
  primary_reselect always \
  fail_over_mac none \
  min_links 1

and the interface got the MAC in question. That gave me the idea that something 
could be wrong with setting up/configuring the bonding interface via the *ip* 
tool because it works well with systemd-networkd, which I think doesn't use the 
tool to configure the network interfaces.

So why does this happen?


[1]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=949062&archived=False&mbox=no&mboxmaint=no
