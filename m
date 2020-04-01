Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C192919B481
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 19:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732308AbgDARGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 13:06:44 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:44632 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbgDARGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 13:06:43 -0400
Received: by mail-lj1-f176.google.com with SMTP id p14so206301lji.11
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 10:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WcEBFt8Q31rH+6hraCFFSxN9Untwnfyx1N+KciANqbY=;
        b=A1S2Efgu+GyfxBDxXHmSHeG1Cas+GsEtXye4QYcz36F4YfFHYUCf4NMn8CJ6sgneiR
         BGiAYQmCK+zuA5ddWSt7mGK6HLA2G6qaen3penNJlR75DFXs9xNyHHUq7/Od/6npFtkT
         Ec+iHPJ5ephWPvkotLgq08xBjSWEGr+JqXZVBJul3iPxf8JXwBO1ZYAA60BNYYYWQWVd
         y4ZWuRiEWoohkk+Mx73Jgb2bLUStZKz6efJ+DRSSu6Na7k+CUIGVaHg3Du+ap4skDzdg
         +o6u1eca1KpM+YgI3PycE6PRXh0B19XegOlRO+az73Q65w3pVD8DgiRMQtJs/F0DASL/
         OUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WcEBFt8Q31rH+6hraCFFSxN9Untwnfyx1N+KciANqbY=;
        b=T8aBC06roWcjchgv2x8JJeU2M8V7kJdXAA0T2kEF8UmD7lCM19zaSpH1a6CWrOyucM
         Sd0KFnQk8H1EYvxqaF80z7ZkBt4vQzknSuh51SXyQAHTlCbyq+KHBzE9j2JAL4tXnxN7
         mgfb9wo+dG6zdz0p0A2FzSF402BoJpbetDkiakzb1c2gzfbopJH4NLg/jWtwKmgmJBYK
         l1BZ9bihen4Pfy5ISg6zhF2WpmDfCCGpjhBJFLpuDVjp1W1iOJRk+Xt5HJ9iiuTeBxzY
         zyaJ9HdU4VZo4yMMYR+9w8Ruz8qJn2MKe2WPlsFWXWk9omf1IhOCe6vZHa8EH3cYuOXR
         p56w==
X-Gm-Message-State: AGi0PuYk0VTfbBVeezm9MEBv+h6UwiyU2lca+zDy7mRH94trf2jlyM/U
        qsC7PcrRF74mon45pO8mRhxx2qM21VHT862XjuS5ufvh
X-Google-Smtp-Source: APiQypKJca9Zwwi0S4yMwxoYSJmZ+bOG7/ePiUXnQ5Ja1C/RnX95LSsCj1Iwej3lZadWMv6tuOXvf9hIuBK+fA/CCzY=
X-Received: by 2002:a2e:8e99:: with SMTP id z25mr5236902ljk.72.1585760801442;
 Wed, 01 Apr 2020 10:06:41 -0700 (PDT)
MIME-Version: 1.0
From:   Nagaprabhanjan Bellari <nagp.lists@gmail.com>
Date:   Wed, 1 Apr 2020 22:36:30 +0530
Message-ID: <CABDVJk9Btt8bpXr40EL_O9bqY-wAd7N5P9ghp0kTpDQkc8n4=w@mail.gmail.com>
Subject: Proxy ARP is getting reset on a VLAN interface
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I need a small help w.r.t proxy_arp setting on an interface - even if
I set /sys/net/conf/ipv4/all/proxy_arp to 1, doing a ifdown and an
ifup on a vlan interface resets the proxy_arp setting.

This does not happen, for example on a physical interface. ifdown/ifup
"remembers" the setting and applies it properly. I am talking about a
3.x kernel.

Can something be done to keep this from happening?

Thanks,
-nagp
