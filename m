Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697479680C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 19:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfHTRwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 13:52:16 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41312 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfHTRwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 13:52:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id i4so7030397qtj.8
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=s21+R8BhQRQkHzvnG5Wp/7k41zonwA/yuxp6NlTkwKE=;
        b=oqLkqgBTlMHDx+TWDyUIxiaA96/y81v9C905DODcmqVqH7Qql2Bai5c+2PFMVKSWHR
         uQol4HnQQBkpIwRDcgzvRCk/RhJCDGZ7nEpp4RHMuFg6HZ9CVy4nyXwYu45yZXEBH42M
         yLbJNX8AkfWUlfNiJq8CsWBZ94NRInZlGCUnBYRrT+AT2/n2Eo1naxstdB618xuyhqFd
         ox38YY1x4mgQ3B7qq0uznJ+7F0QKWXaS0Xs0MU8qymJ6VY/bNS97Xf29E1y8dTgDc0Pz
         T2ljccWGSRDLjq75R0189kqw4fzkoT1sDyQYbjdPj1EC//t05ZliHF2r8sPyhyeW4stJ
         DKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=s21+R8BhQRQkHzvnG5Wp/7k41zonwA/yuxp6NlTkwKE=;
        b=jILGuiilBxL9EIY2PCKxppfSjGOLTq7aD03Of/miE0xZIyie5k6EVzdRc06OoXvM5S
         doVgZs94bGFp1K8CwpqxOjUlkz1x5jxbg7pB6RoSb70y9SJ/RNzweCrVLJV7Cib1P9+M
         s1cjDEzXzmEHXAbAH4158b2vDTp8SjGdXH1dcBMnygV+FtlaVGMUqBTZIs89OjiYRbXC
         z6BlmV6QiU8p22sSTdi7H8KuXfHO9LfYZD8wI1J2S7r4w5aVuuZuRLKviGCfHKA5x+t1
         MO5k3TZmnagVVravBrVpNYR9ZmcWEuGt+cmV69HXL6lr7GqZ902pIJq4hfYf39fsDMkt
         6Jmg==
X-Gm-Message-State: APjAAAV5sqJ/iK20kHukZq8olDzY907Jcf6MnEoos3oXS90/Z1PtzQJR
        /HCufoDYChYWgLMUBxbBlkHyB9XU5gA=
X-Google-Smtp-Source: APXvYqz6MymVQ3wqo2ZuG9l9AGk0Z4buBaHjKcoHM4au5mNLufYxDATxIodqYWjsDoE4fA8V19/Tpw==
X-Received: by 2002:ac8:50b:: with SMTP id u11mr27126344qtg.308.1566323535406;
        Tue, 20 Aug 2019 10:52:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id h66sm8837478qke.61.2019.08.20.10.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 10:52:14 -0700 (PDT)
Date:   Tue, 20 Aug 2019 13:52:13 -0400
Message-ID: <20190820135213.GB11752@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
In-Reply-To: <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain>
 <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, 20 Aug 2019 12:54:44 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> I can agree that this isn't one of my brightest moments. But at least
> we get to see Cunningham's law in action :)
> When dsa_8021q is cleaning up the switch's VLAN table for the bridge
> to use it, it is good to really clean it up, i.e. not leave any VLAN
> installed on the upstream ports.
> But I think this is just an academical concern at this point. In
> vlan_filtering mode, the CPU port will accept VLAN frames with the
> dsa_8021q ID's, but they will eventually get dropped due to no
> destination. The real breaker is the pvid change. If something like
> patch 4/6 gets accepted I will drop this one.

I wish Ward had mentioned to submit such academical concern as RFC :)

Please submit smaller series, targeting a single functional problem each,
with clear and detailed messages.


Thanks,

	Vivien
