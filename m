Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D2F1214C6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731285AbfLPSOr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Dec 2019 13:14:47 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38187 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731271AbfLPSOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:14:46 -0500
Received: by mail-pj1-f68.google.com with SMTP id l4so3335345pjt.5;
        Mon, 16 Dec 2019 10:14:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=iKHvVH+HZnjDbJQPL0E6+fOCqkI3jX6nM/ac/madaJI=;
        b=pSvCIJeb9bK+RjKkNKYpVi8m2go7CO14m2wyLaQsbY987KOn5CS2s4acngb+Zc1Lqx
         F2SxQ0AGN7ktLW8Xpp6Seh/Ei+vFAZQ3iOWKYf8hDtU8Va9N2SzMSiwREfxlDehhtKMh
         WRXMBxJtmeleVxDzxnJLkPi4O0ihI/T3AdMEF9roDa4DalhmKVgnn4omf3Fl9mb5kLpS
         ALBoHZf8TR8OIsD1izcZ5T8naJJfwukF3uf9lX4KixAEyH7os67+6Nmiinuj/XfufYcH
         azTN08MnscWxcecMwTPhgpo6S+hUIsiFExPG2DGa3a3KcK4oAIk7bDSVoSXmqpvD8T7p
         NwDQ==
X-Gm-Message-State: APjAAAW+Rv21/vm7oHV9vCXZksgkcKvWycYLJpLMK4f8YTUXKCiIucDE
        Llg6mzLSTjJcSheYxvd43gY=
X-Google-Smtp-Source: APXvYqzfoFlf1X7ioFA4tGzBd5l+6HBYOY5ZCzvtp+oXRtEjaFae67nleEnik7T+sQlB66RtAoGLHg==
X-Received: by 2002:a17:90a:230b:: with SMTP id f11mr501357pje.124.1576520085802;
        Mon, 16 Dec 2019 10:14:45 -0800 (PST)
Received: from cweber-x250.corp.meraki.com (192-195-83-200.static.monkeybrains.net. [192.195.83.200])
        by smtp.gmail.com with ESMTPSA id k29sm23467456pfh.104.2019.12.16.10.14.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Dec 2019 10:14:45 -0800 (PST)
From:   Simon Barber <simon@superduper.net>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: debugging TCP stalls on high-speed wifi
Message-Id: <80B44318-C66D-4585-BCE3-C926076E8FF8@superduper.net>
Date:   Mon, 16 Dec 2019 10:14:40 -0800
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, ncardwell@google.com,
        netdev@vger.kernel.org, toke@redhat.com
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I see Macbook wifi clients seemingly randomly switch in and out of using GRO (I’ve not yet figured out a pattern to it), and the packet rate when they are doing GRO (on a download) is much lower, due to ACKing one in 8 packets instead of every other data packet. This has a big impact on performance.

Simon
