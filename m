Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF8DD1DD4
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 03:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbfJJBFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 21:05:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45592 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731751AbfJJBFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 21:05:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id c21so6213323qtj.12
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 18:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=yslD0vJC0n7yMnrVfWzX5AGUfr1HfWeNc4MzZPaHSHY=;
        b=WyIuW2hye9ZmEo/GTtA2gLqrtzYbe8VOlPXTm4FBV5cOh2lJUlsADsw4DnYwux5qvZ
         Y7M3RYA7fOQUZe8NC4wFjCGJ2pvupiDBZTpOTvj4gc1fMb3aX1aUilvsPJeOZKLaG4ig
         8Foz3q/BpYfdUSXRy7SKSAAhffvcO+h0m6TxcEPsMwNULQJa4zkfwlQQDw+tzW7TkifG
         +Jk/v/f1c4Gzr+XsxydmUhpad+N2rIXf4Zui2mhuPhvsWiv/iiwWQo3s1c4uSz8GZfcq
         WPAuOM47UFIxrhQVhODuUTlK8Vu76DBZ3WHeCitbRaDqRfe1+JcS9+zxiDNmqZp2ZLH4
         Qjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=yslD0vJC0n7yMnrVfWzX5AGUfr1HfWeNc4MzZPaHSHY=;
        b=fU4bJtEGh0AbnzF9NXKIwd2wfE2uvrzGDu2b1d0LWRuvhfskUMcO5X+sBbbpdVaa/h
         Z/kwt7DRUmt8+jJ5SrA/L5QqzKKzH1Irt9+EvDHicto+JfI/wA8t/Dw0QSNnYHX4tCvY
         Gx2cSrFZlgzH4+dgJeV28B0dhlCZwkMmcrx3sgIJpBTDzAdkVvr3Q7YXO4jgcLHXthhP
         bBAIyWxWpd1845b6p6RBDJHaoRcLshsFyKJrwfnb7c8ah0IXe5w5H5LYr2qrzum/h3OJ
         3bVyENQh5p+zA7zmMOzflJu7mOJIpufwwObDYLku+qDiOrrBLUQHv9uAGaCOCg64aj7n
         Bz3A==
X-Gm-Message-State: APjAAAXhmXsbcBN6sWwGtJa+fyzleeBkfAmyu3WkrZ4ON0/RNUJ2TSZz
        J1IkK8kTQbhoWfpCpRMG066Sgg==
X-Google-Smtp-Source: APXvYqwiOyMvB2nJhHhwXsen5XMgYRRQKdvyCLjMwevviZocanx/dwgk47OpcwAqvkSsUA6lXoykMQ==
X-Received: by 2002:ac8:33d4:: with SMTP id d20mr6944047qtb.204.1570669524672;
        Wed, 09 Oct 2019 18:05:24 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v5sm2688271qtk.66.2019.10.09.18.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 18:05:24 -0700 (PDT)
Date:   Wed, 9 Oct 2019 18:05:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: Re: [PATCH net 0/2] s390/qeth: fixes 2019-10-08
Message-ID: <20191009180509.74cb1ce6@cakuba.netronome.com>
In-Reply-To: <20191008162107.95259-1-jwi@linux.ibm.com>
References: <20191008162107.95259-1-jwi@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 18:21:05 +0200, Julian Wiedmann wrote:
> Hi Dave,
> 
> please apply the following two patches to your net tree.
> 
> Alexandra fixes two issues in the initialization code for vnicc cmds.
> One is an uninitialized variable when a cmd fails, the other that we
> wouldn't recover correctly if the device's supported features changed.

Applied, and queued for stable.
