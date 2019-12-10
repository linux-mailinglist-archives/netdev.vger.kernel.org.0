Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4854C118F9A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfLJSQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:16:41 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36286 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727568AbfLJSQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:16:41 -0500
Received: by mail-qk1-f194.google.com with SMTP id a203so7119349qkc.3
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 10:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Js+t/imDnAhNiv+s8X3Rf/niWKTG1Cd0eo7I2V5WDgA=;
        b=sPHsMOc88EUoOe/hcIbbxqxMairaW0tiKYqf0W1UhlZNzVRiSjC9z3hJD9lvr2HnZd
         wvtedcSIYZHca7riIAsF2f0XNQ5CmsboZmTTmvCcW2sEGyiAe5XFdFjrxjGDFSAllcbK
         JgXxoM6nLcuIQI0XvL9zhzG1ZmSx6DSnMjjvhsxWAxqkG7f4qdwFuZ7PNHhwcf089JgA
         Iomz230rH6ei8HFpsXXvzughInlwaH1Rr6/7saAFeKuIiTQYhuodD+filjvmkvjvgJ3U
         ENdRRMd9TaYXBEMwxL6tUTI23+6oVnwNwxcHqPM+xcJhHKKmY02nm0J36+efLQw40IUG
         BpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Js+t/imDnAhNiv+s8X3Rf/niWKTG1Cd0eo7I2V5WDgA=;
        b=iA2Bw99nCGxQ0mo0r8i88waI+xOhDK6U+Okcl0+uf2AhAmRVoc8pwsv5Slfx67gZw7
         qhI+amcCDQdLWhN1vTZvfxajgeMqz62b9RNTRSWqnPburnYa8kvAS3f8PM13xGp04h4A
         3f8evJOeCTbD1wi4CDmQOnj5fQCeZHfxDQiOonSjLHesHw5jWKvUfAKUta3Y9RZSPREI
         QOnaH5DyEi3i44BpldZ9ZSbAJ/cUd1AYahDWHOJUbEjBXm6/qB7aSC4Z+ezyuzUgZcSF
         9fOLqSEHbprzZFW3k2mSPXR5K3Ij7pkW5eGGRjhco+Qrhdtr2bFCkNCUwhiKDMlWo/i1
         P1JQ==
X-Gm-Message-State: APjAAAWc75HdVuVUXAjw33cZ0d3MI53MB97KkdrAVKFU+W4AHai5LnTc
        EiOTvpwycDJGzOk4OE6Sx73rerm2KTc=
X-Google-Smtp-Source: APXvYqwpkDh+vDXn+8s0scyroCk31thpaMR68T54lWKcjxn6wrW2TJy74i1kIXSn4LhIFx+6DxxpVw==
X-Received: by 2002:a37:7bc7:: with SMTP id w190mr5690067qkc.391.1576001799963;
        Tue, 10 Dec 2019 10:16:39 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x16sm1143414qki.110.2019.12.10.10.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 10:16:35 -0800 (PST)
Date:   Tue, 10 Dec 2019 13:16:33 -0500
Message-ID: <20191210131633.GB1344570@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH iproute2 v2] iplink: add support for STP xstats
In-Reply-To: <20191209161345.5b3e757a@hermes.lan>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
 <20191209230522.1255467-2-vivien.didelot@gmail.com>
 <20191209161345.5b3e757a@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Mon, 9 Dec 2019 16:13:45 -0800, Stephen Hemminger <stephen@networkplumber.org> wrote:
> On Mon,  9 Dec 2019 18:05:22 -0500
> Vivien Didelot <vivien.didelot@gmail.com> wrote:
> 
> > Add support for the BRIDGE_XSTATS_STP xstats, as follow:
> > 
> >     # ip link xstats type bridge_slave dev lan5
> >                         STP BPDU:
> >                           RX: 0
> >                           TX: 39
> >                         STP TCN:
> >                           RX: 0
> >                           TX: 0
> >                         STP Transitions:
> >                           Blocked: 0
> >                           Forwarding: 1
> >                         IGMP queries:
> >                           RX: v1 0 v2 0 v3 0
> >                           TX: v1 0 v2 0 v3 0
> >     ...
> 
> Might I suggest a more concise format:
> 	STP BPDU:  RX: 0 TX: 39
> 	STP TCN:   RX: 0 TX:0
> 	STP Transitions: Blocked: 0 Forwarding: 1
> ...

I don't mind if you prefer this format ;-)
