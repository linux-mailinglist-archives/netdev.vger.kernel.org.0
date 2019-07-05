Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46080609DE
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfGEQBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:01:53 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:39084 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGEQBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 12:01:53 -0400
Received: by mail-qt1-f178.google.com with SMTP id l9so3356278qtu.6
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 09:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=ztvj3j8g/sQ1Z4GqA1dF3jVD/yJ+cSLBID+9eATOJQw=;
        b=TMtfIOB9+SWZquLPH79g9pazm+2DG880/yUJXTy6GO7xVAPjY7bhwJsl+7nE3BMIav
         Wqs6fAdwEao27XaTuTPoxCzX2sIKyR6Bvk0fpetSFfF97C+bVbcs4w2UQOFdNCrVncnN
         LWeXFfcFXPS4J2J9fJKmf+Cvdu9l4z1hxRif24U1PW/giODFVxoR1IsFcsMKTEd/BsET
         XIcgBIOxZx88Qbv0Yww2Vyrk0KkVo+G/8n32cm0Mu9wQA2vVgLImoEHMzVlOLYvTzZMC
         P4iB1b7WtJhLpIqMF/dAwwLaGzycWjWIjenJxUlPCx1Z4owBOfCtExdyFrIMQYrojCTz
         kzVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=ztvj3j8g/sQ1Z4GqA1dF3jVD/yJ+cSLBID+9eATOJQw=;
        b=n85M9Ct0138+UG59nCOVw0wlnjA2osrLF84U//NnpFmuFRMXIMNBJ+z4fgpZPRacdz
         D2BvsrpUoHzjqdnKs/4VCSf646x4FHmfjFhQqC393kzZxgzHsiG/Si6tfJVuKgrzqdBY
         Wptv8wh6LmmS71Katpzn4WrLjyypsgNdhneBoXUhBiWBF9xzVBLP1IqMMqRjhThSUSjj
         wcBn13Xo8E3RSSVbJhVcDPrmHoarcGlOoX3zv8d1Va1t13wipHjf75ZJUfqWCL5kBKe4
         Wrdw9uxzJchsHecsPo9xKAVH5c8O06MGqRQib6yIFwG6c3ku95ETgmp+2HW/kqKAaElK
         nWeQ==
X-Gm-Message-State: APjAAAVZh/gK8jj5DCUbxQJOdTb68ejt7oozlWc34uQCiVd6v4D1y8qR
        eDjiv68fobamBlzBXB4xSVk=
X-Google-Smtp-Source: APXvYqzojZSaDP40XjkljcI6Cnf04mSwWqYnoBY8DxXHOUckSuUSiJnd+aajGAaA/U3I6Xii0LiWBw==
X-Received: by 2002:a0c:d604:: with SMTP id c4mr3896346qvj.27.1562342511865;
        Fri, 05 Jul 2019 09:01:51 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c40sm4397758qtd.14.2019.07.05.09.01.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 09:01:50 -0700 (PDT)
Date:   Fri, 5 Jul 2019 12:01:49 -0400
Message-ID: <20190705120149.GB17996@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Ido Schimmel <idosch@mellanox.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
In-Reply-To: <20190623070949.GB13466@splinter>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190621172952.GB9284@t480s.localdomain> <20190623070949.GB13466@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Sun, 23 Jun 2019 07:09:52 +0000, Ido Schimmel <idosch@mellanox.com> wrote:
> > Russell, Ido, Florian, so far I understand that a multicast-unaware
> > bridge must flood unknown traffic everywhere (CPU included);
> > and a multicast-aware bridge must only flood its ports if their
> > mcast_flood is on, and known traffic targeting the bridge must be
> > offloaded accordingly. Do you guys agree with this?
> 
> When multicast snooping is enabled unregistered multicast traffic should
> only be flooded to mrouter ports.

I've figured out that this is what I need to prevent the flooding of undesired
multicast traffic to the CPU port of the switch. The bridge itself has a
multicast_router attribute which can be disabled, that is when I should drop
unknown multicast traffic.

However with SWITCHDEV_ATTR_ID_BRIDGE_MROUTER implemented, this
attribute is always called with .mrouter=0, regardless the value of
/sys/class/net/br0/bridge/multicast_router. Do I miss something here?


Thanks,

	Vivien
