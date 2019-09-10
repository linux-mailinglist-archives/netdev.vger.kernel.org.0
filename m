Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F2AAEFEB
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436906AbfIJQt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:49:56 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41209 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436758AbfIJQtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:49:55 -0400
Received: by mail-qk1-f194.google.com with SMTP id o11so17727019qkg.8;
        Tue, 10 Sep 2019 09:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=NEflpFjybs9sPNMB0ibGRgHf21J+8Rj9DdyKXzTD934=;
        b=ra3AuEt08YMBm+5erwcLDFIHiwIf0gaK0F1Ie8DH8OrtluyQcxWFdDOUEGdRSRyXhk
         y6WeZS029xFXawPTU4oQHxwumys8aFvQiAm4RpuevhAM3kVynvFCiNI04W6pa/uGwC8s
         OJmExOj8sRH1PP+ThN8nTsyTpIa+06WVgBXmvBG0mkxsc5d0XVwcwu47PLYXCr4BgXWk
         49K5mSXF16w1NVDqLswkoNsAR+fzTcCGwAKpsLjFrYUNZnTj4B6e1eYuLbpmNfEqf34Z
         K0tntP4qGhO5ZLeJGu1POZq36nSHWZWts6MsxjRIoYGNoORZ3TPKAXsyMnto0+FcDWMM
         5qrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=NEflpFjybs9sPNMB0ibGRgHf21J+8Rj9DdyKXzTD934=;
        b=KZfv8ZdlGvLkk6JvVh+Ebd7jF5i3jNyrkRDX01TyK4wP16n2hTBTMA6Cb3qIgunwKA
         cWfHrXshRyP8F0YW/liD1CFgLzzuH8iPTOdtK/C/wFmGDFjjI4GgYwEfkMzKCEqg9/H6
         J0dWYlZCQkzkN2dlSFYGeT/sIAygkWx11Z6CBlf/IrpkNI3Qn/1Ecvcp5jTmZF9P09Xp
         zIf6gMiChtwo9vj2RfZnuBYLDyMK8yKix3hV69BvbWAzJuNKiKEW2+8C27S4NVS0laVr
         d076/oGCiTbVTbHbIcp7It2brn8vy71CXQXC6x3ENft+aQp2KRuTd/HAVWVY5pJJg2TT
         GUmA==
X-Gm-Message-State: APjAAAXxr8mZJ8YLUzCto1/oBVZv2S9paoOjh5844MlxBrgGN6vFhxyt
        v88IM3Q8T5l7JqiRhvsMsoU=
X-Google-Smtp-Source: APXvYqxEL4jke6sa+R32vylpppkMKeL4MxKYBKn7ZK3Iw/1GGQH63Ht5dvbmCLXjhoCue2nKlmHmJQ==
X-Received: by 2002:ae9:f10d:: with SMTP id k13mr29705870qkg.68.1568134193503;
        Tue, 10 Sep 2019 09:49:53 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p27sm7998341qkm.92.2019.09.10.09.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 09:49:52 -0700 (PDT)
Date:   Tue, 10 Sep 2019 12:49:52 -0400
Message-ID: <20190910124952.GG32337@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Robert Beckett <bob.beckett@collabora.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH 3/7] dt-bindings: mv88e6xxx: add ability to set default
 queue priorities per port
In-Reply-To: <23101286-4da2-2a53-e7cd-71ead263bbaa@gmail.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910154238.9155-4-bob.beckett@collabora.com>
 <23101286-4da2-2a53-e7cd-71ead263bbaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

On Tue, 10 Sep 2019 09:42:24 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> This is a vendor specific driver/property,
> marvell,default-queue-priority (which be cheapskate on words) would be
> more readable. But still, I have some more fundamental issues with the
> general approach, see my response in the cover letter.

As Florian said, the DT is unlikely to welcome vendor specific nodes for
configuration which may be generic through standard network userspace tools.


Thanks,

	Vivien
