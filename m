Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A2F835B0
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 17:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731973AbfHFPvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 11:51:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43258 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730373AbfHFPvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 11:51:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so41727425pfg.10
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 08:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aF8BxWDnk35y215CyrgUHIhlv4YHHjQYRJ6LreQYidg=;
        b=ygpFhjnkvdLvW2f4GfajBe7/3M98ZW1wFpi2lBpy0WF0lyAM/6+BvTLAexKVg0f/T9
         8pXSB8Yyo3G/uH7yTZdI+6MdTdkwZdVNRMZNhWzbuDes8265dzXjxKICkm495TevTZDF
         sLPb88n0+Y+CJRWpVNRxreOBm777lXX2B0aX9OtGmY+1ZpnGuAKi9vxwew1S7IOmCsGd
         UmUJmqLhjFinyZiBhgW1IiAPPtp82o5wttpKjyysrZKkuPbAf0nvusGeGTjrPuQ1wMQw
         mKSREjBgWfU0QdizMm5W98ze0/V9uFTycbaheadS/8xt19VwCDF9FlZYQiB2sZ0OyXim
         m7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aF8BxWDnk35y215CyrgUHIhlv4YHHjQYRJ6LreQYidg=;
        b=e5jAqj0hZeBTOeEKtbXW+L7rCM8ZUX6nM31fLKa48r0dNTFqtHljSu3kzozW+MCnkS
         VmMM8cfFSvu3SRAC2QMklu+YZ2Pbs4am0zKy1NbSI2UNIi/w8tz/dKct9WeMoSIwIpJ2
         PLT5G+W2WO5JTZqpsoPNZtTvSqRfzApB5fNrEfvcTTOUpk7xHaGOVvQNLRLe5SnsRYse
         fdAO/Wl/pAN6O4BTdIFbl5ubgM2jrQTjUu1NXd1p7eJ82oy9oXef6Rl5p69y+VhBDsdP
         Wl1H5eydztzw8qx6S8rK244d4cmFREaR1AbcciNA9YEgV4r/Xz5PkAULAC4YwPfkP0KE
         mZwQ==
X-Gm-Message-State: APjAAAUKNLVZyeidMDZP1L6VEW4vMhL0d7ZgGdIXNIAYkjWzjGUHBA2R
        QC5VyFDm7mGxQ9XA932VFQIAMKZvYrc=
X-Google-Smtp-Source: APXvYqwIpnijuig+KiNkcVOnTPRAb73TpnlsrppVT2MUvkMGZbdHMRwNGibcbz0cLr8H4YkipeGvgA==
X-Received: by 2002:a62:3347:: with SMTP id z68mr4489032pfz.174.1565106667513;
        Tue, 06 Aug 2019 08:51:07 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k8sm82533023pgm.14.2019.08.06.08.51.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 08:51:07 -0700 (PDT)
Date:   Tue, 6 Aug 2019 08:51:00 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Patrick Talbert <ptalbert@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ss: sctp: fix typo for nodelay
Message-ID: <20190806085100.0753a18a@hermes.lan>
In-Reply-To: <20190803083741.24122-1-ptalbert@redhat.com>
References: <20190803083741.24122-1-ptalbert@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  3 Aug 2019 10:37:41 +0200
Patrick Talbert <ptalbert@redhat.com> wrote:

> nodealy should be nodelay.
> 
> Signed-off-by: Patrick Talbert <ptalbert@redhat.com>

Both patches applied to current iproute2
