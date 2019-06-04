Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA25734E11
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbfFDQ4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 12:56:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38266 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbfFDQ4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 12:56:08 -0400
Received: by mail-pf1-f193.google.com with SMTP id a186so12342566pfa.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 09:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3B8P0BFS4DhocLRykYWlhTzC23gx6CLT+t2gAklaId0=;
        b=dWgRnwp+3M4Liz4LWnka47FAIR1SdBnoYn0Nw/lETJ9vo4rjuniu6x+DKE0qCq2OgD
         EtkFiiRNuLyQ5iJ5ojoHkE9PTk8tjAl1OzKYaJL8ybxvrfb6SUhtHbHyFNSDRwJ7lGSd
         Q14a1Q7nzst2iZQMLIHgqaPt7cnNPm9UzHiuZ8PY8Iuo7w5R1LlS5CTBZHX4ktXL4d63
         7ds5IFU5LX4mlQUoEv7+ZvgHN7FwVELazdZKJr5c1iUUQA9D+OIPDZkZT+IpZj3UyP7M
         QK1rXkg3FvbMxHSES7Ebfod+gQkJTgd3g5Q60+12B+AmZw/VGHyPLsdZq2PNagKc9x7p
         V5FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3B8P0BFS4DhocLRykYWlhTzC23gx6CLT+t2gAklaId0=;
        b=Zs+6UBgCrCvrOdlfkYa60Sd22Hw8zoRDJfa2kx7MYJPuvDDz9zGrlV7xshTitoKdgV
         42pq6vFRo//EZHPZ/WTSlOy71oOSF17xw/Bbk8IBKQDW7OhL9w+dG/9NSBoYzutuVexW
         cw1W+U0DhtNoVfIGnyMRWPnnpcNftrVhUkq979zLOlk2jnzaNIV2P3jXdkqcOJ4JVjR4
         VNmX7UWO+6jy1vW6XEJuT4yoDrvQ9WWHJ9ygLd7RPg7E12VmK/2geg3BWLoCKBbD8CN+
         QZWqXy9InXmNCCXVm6Na0FTZS1mcr8Cfu0xWFpvTcl9dmgC6kbtCGWZ9HSKo4N9izoZj
         PbqQ==
X-Gm-Message-State: APjAAAUhCy2wvv4LOcU760NzsXKNHiU9/k+AbGBdkq8IYboinZbkVfOU
        6KJw1r6TXpHioexGx2L/ItS1bO/atDg=
X-Google-Smtp-Source: APXvYqxK9FAKquH/jCZMzor5chupwdDrtN7vxjtI9yQ0wPWW1I0a1zzVK/kfW3e3UpdcqV/l6dGvfA==
X-Received: by 2002:a63:f44f:: with SMTP id p15mr36242869pgk.65.1559667368002;
        Tue, 04 Jun 2019 09:56:08 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k3sm18119236pgo.81.2019.06.04.09.56.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 09:56:07 -0700 (PDT)
Date:   Tue, 4 Jun 2019 09:56:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     aclaudi@redhat.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc: simple: don't hardcode the control action
Message-ID: <20190604095605.5318b1f4@hermes.lan>
In-Reply-To: <25d2af8d9fc5af184ad1694c2963403753aef53e.1559294588.git.dcaratti@redhat.com>
References: <25d2af8d9fc5af184ad1694c2963403753aef53e.1559294588.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 11:34:46 +0200
Davide Caratti <dcaratti@redhat.com> wrote:

> don't hardcode the 'pipe' control action, so that the following TDC test
> 
>  b776 - Replace simple action with invalid goto chain control
> 
> can detect kernels that correctly validate 'goto chain' control action.
> 
> CC: Andrea Claudi <aclaudi@redhat.com>
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

The commit message is too short for me to understand exactly what
you are trying to fix, and what the test does.

Please resubmit with a more complete description. Including before/after.
