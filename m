Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6FE15120
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfEFQWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:22:11 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:35952 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfEFQWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 12:22:10 -0400
Received: by mail-pf1-f169.google.com with SMTP id v80so7038780pfa.3
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 09:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gQf6uxeELmFB44YrJy5r68P7xnukvUFcDTF2Bos7l7Y=;
        b=Z0pfl2l15WgWly0XPvr2GWS9NvAwHlyJMrjSRobne4oKbne9nK8whYcb8rKPZqI4vX
         v5S7SwOiTUcoUSLFAuDOJKqJzrUfuTK7EGlUIHsH4Twi4ZOyzLRUmslN/XX4E7igsR7a
         wmTNTYX2aFfeH8VKXmpGhIufRvUdGF4UwP4W9K5lM38z4OfoOIV85XFU4qxEmxCC5chL
         ZktK6P7ckzpX1s5m6Jjo6a8QxDjoYkSka+SJGwHqhAWQnQVw5iNjK5F9ku65XCOJuPF7
         sxHqSLhpl8b/BHBZ39s8PSTS2BGSj2ECMpJM7C2hJCw1V9JBYsU2wAIrmVGiYyI1DeP1
         vwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQf6uxeELmFB44YrJy5r68P7xnukvUFcDTF2Bos7l7Y=;
        b=XlCizDm0GGsygicyTVGOXyIDIytJ53LgmT3PCGBaZTk/FhDsUac9h6hfa+AJ2aBPnA
         ALFlf3d3zvjg7wyBBmJB7snk6gI2fTKm7CVUkdjybOsriX6chYpLO23oZyCrZLjfeQ6H
         cTGVzkiYhZJ2V5GldmDez8a3++fGXKTKmueWZ59iEc9Jkfo799GDbj0jBNnQZVI78L/B
         ZKqopbBZPZAmi0xSmnQJvQBDkfsY1bPCS1uW8pderdZ3w0dtPDNFKXLbvVJ9RD3VXYRE
         b+g3Brn+q7LDK7UhfSC1VMLZSNAlawNipwAJ2nkV7+EAKZDPKvl+5+SZYuKHWW+ZI/79
         zDTw==
X-Gm-Message-State: APjAAAXTDtBrVHIA7zjQPe9xX7vrvcHPUqER6I/9igoNQj/8wzv0VL05
        IWl8mRnUkLxIu8Wa8WvCIJJrvoYECpA=
X-Google-Smtp-Source: APXvYqxbyMljl0YjqSThZIWxGh2sN/FkVULbB+HXtn7TXSVRCE37/rw8vQiNPysetJj0XxtFnBp4Sw==
X-Received: by 2002:a62:2b4e:: with SMTP id r75mr34095379pfr.131.1557159728958;
        Mon, 06 May 2019 09:22:08 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j9sm22094853pfc.43.2019.05.06.09.22.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 09:22:08 -0700 (PDT)
Date:   Mon, 6 May 2019 09:22:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nir Weiner <nir.weiner@oracle.com>
Cc:     netdev@vger.kernel.org, liran.alon@oracle.com
Subject: Re: [iproute2 0/3] Adding json support for showing htb&tbf classes
Message-ID: <20190506092202.5ce6b4bd@hermes.lan>
In-Reply-To: <20190506161840.30919-1-nir.weiner@oracle.com>
References: <20190506161840.30919-1-nir.weiner@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 May 2019 19:18:37 +0300
Nir Weiner <nir.weiner@oracle.com> wrote:

> Adding a json support for running the command 
> tc -j class show dev <dev> 
> for the htb kind and the tbf kind
> 
> Nir Weiner (3):
>   tc: jsonify htb qdisc parameters
>   tc: jsonify tbf qdisc parameters
>   tc: jsonify class core
> 
>  tc/q_htb.c    | 19 ++++++++++---------
>  tc/q_tbf.c    | 20 ++++++++++----------
>  tc/tc_class.c | 29 +++++++++++++++++++----------
>  3 files changed, 39 insertions(+), 29 deletions(-)
> 

These should go to iproute2-next
