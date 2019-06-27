Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CD858E0F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfF0WjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:39:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33266 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfF0WjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:39:02 -0400
Received: by mail-qt1-f193.google.com with SMTP id h24so1275603qto.0
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 15:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XajBjJKfw5QFWq4K7AZSGN0xkO6OyQwRKB/4XRMLcq8=;
        b=T+U9W6S0ezBddMHs1vs0d1C+cpTAXkG9wuUJs+G1drajWsxXYN7ghzB7gDr3YYMlq3
         ccVw4uXt8O30DFEXY6x1SYR7SwfO+gWh5tLcIMAlsPCtIN951FiJVVslEce/8KA2VhaC
         z6vg7S3iKsq/sFH0GHiYMmUQc2Y03IoPMXkM28gChgJ3aJohbxGFS9fJ8APEUZsukyZH
         26H1CvXoV6Nco4waEK98jQ7Txw1cL82MkT0h7XzKsLPIMnYmaEdRbElY8p6w7zn2mQhX
         oT1EVoJsBeJj4qvs+z+iUrArChmjH7kxwUiRZwvn+yc2mbj3YlBiyFn0Jq7YnRKGRQIG
         5UXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XajBjJKfw5QFWq4K7AZSGN0xkO6OyQwRKB/4XRMLcq8=;
        b=h8zKUMMoQSuy+xi/jFn3KrC/iVM6NgQ/KNXbYC0OSX3oexzElKmQbSFcYCbwFqzqn1
         9K02xSkApCHPBYz8GtIRdleiBsitGCoK92Xqtp/1xWtKT+zBFx6EzpItgALs3sNjnE/l
         4GR6x/HZIn9MouQqWSQ+GLVK61hSzrWyN82R7D6smpyZiv8ik82tsjaxFL7lS59nv5ug
         CBSW7xFFRXVYJC+X/nDpO3tiCTirfSXfKGdJdza2bRMSsk/bVx2W2re/qJvkk9ul+j+/
         /9DM/KiLwRDb+jXk4ekft85VPcicUhbzq1pTEzBBLUzVQpMbGrDALwohzReBI6B1Qrtz
         HJdQ==
X-Gm-Message-State: APjAAAUgsXFX+OC1AaQFnQe8e7wfNR0sd8ck7qmuPCobwePWnxVVNPM7
        QkPan9fksGd+y6EfUdFXGQz9zQ==
X-Google-Smtp-Source: APXvYqyYy64yCEz3Zw+ixe1ps9Po+sk0OGm4fw58mAZSzP2Tn6ccL044hzTu6b6L3Mm+jfpQdUT9kw==
X-Received: by 2002:aed:353d:: with SMTP id a58mr5364020qte.42.1561675141376;
        Thu, 27 Jun 2019 15:39:01 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o5sm204846qkf.10.2019.06.27.15.39.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 15:39:01 -0700 (PDT)
Date:   Thu, 27 Jun 2019 15:38:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <saeedm@mellanox.com>,
        <maximmi@mellanox.com>, <brouer@redhat.com>, <kernel-team@fb.com>
Subject: Re: [PATCH 2/6 bpf-next] Clean up xsk reuseq API
Message-ID: <20190627153856.1f4d4709@cakuba.netronome.com>
In-Reply-To: <20190627220836.2572684-3-jonathan.lemon@gmail.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
        <20190627220836.2572684-3-jonathan.lemon@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 15:08:32 -0700, Jonathan Lemon wrote:
> The reuseq is actually a recycle stack, only accessed from the kernel side.
> Also, the implementation details of the stack should belong to the umem
> object, and not exposed to the caller.
> 
> Clean up and rename for consistency in preparation for the next patch.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Prepare/swap is to cater to how drivers should be written - being able
to allocate resources independently of those currently used.  Allowing
for changing ring sizes and counts on the fly.  This patch makes it
harder to write drivers in the way we are encouraging people to.

IOW no, please don't do this.
