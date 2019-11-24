Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B45F108161
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 02:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfKXBta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 20:49:30 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34764 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXBta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 20:49:30 -0500
Received: by mail-pg1-f193.google.com with SMTP id z188so5316345pgb.1
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 17:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=f3cnDtSWrzhlJ/f7hX50pKYLqzfFggDpwt4E1h2xgOA=;
        b=i8e+pougR0WRoeZVP+6L6k6bEB115JqgEECWEo44LDAHBrc9IOkk6hk729t+vvNx6/
         Qi7h9JmYONdyCSYDQ4sa8zq+iz7s9yVRXKv5bvExlkCsY1IR0Mxcg71AcVfyn2WJFk2r
         mnA2dyjf5wXhhnKvjSXn0g0zPEJH7fnzSU2cuF4YZHcLxX/41oTxa44jEcyM67pforLe
         MnKkArTNHl74pUOOeTOZulSzL4sqw+QBIjpqShtw+wdL44U+r3L3aDMLSnoq2uLtvfqz
         IVuFt+GI+NzCH6hofjM6i47gC9SUUgUmiNW1XPZ4ldMWlcbLnKeCibAtBjidHWG/rWIk
         wM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=f3cnDtSWrzhlJ/f7hX50pKYLqzfFggDpwt4E1h2xgOA=;
        b=mLQrrem5EB73OCGhkOSQGBkc1xPBX1yTB3ardmykAKE0cXc7XbzQVDIFEZh0fRE77t
         u9tWcLAQEkvwJqvYUT+dIftxnuB/acNRFj2ZO5DfbqQBvYTv8FbcTCBGMhrbJrptWWQ/
         391G017dgZmVFO93ignn4yIx7ezYH2uFB8PNZriWoWSqNrmKq7b/GxUIClkg9OowVnro
         8Tvg6LWOMMwCqBYah9WSiizhOyZEIYPgNA7F15BBkiqd8NvHxsP82QrDdp9dpK1yWohM
         GNIM8qDgjv3rsESEaEm6dZINXJOGTkAZBQY5iG2HdylpfovBjwpq3d4XR5+P6heKdXQ6
         KTiQ==
X-Gm-Message-State: APjAAAUm5czBt+j/t46rMfCGIqvWpSBc6UYU2/RvqceH7iLh/lWHjQQl
        C3M7yZ9L0dSfJVilpOcNnaa9aA==
X-Google-Smtp-Source: APXvYqwRL0J+gKnbkZ67+z3jCjqc9eVJjiIXaUqWYjR3VGNBBClttqrqhls1DcUga2UuguosnC+TBQ==
X-Received: by 2002:a63:1b5c:: with SMTP id b28mr24303855pgm.69.1574560169449;
        Sat, 23 Nov 2019 17:49:29 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id x190sm2926638pfc.89.2019.11.23.17.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 17:49:29 -0800 (PST)
Date:   Sat, 23 Nov 2019 17:49:25 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        julietk@linux.vnet.ibm.com
Subject: Re: [PATCH net 0/4] ibmvnic: Harden device commands and queries
Message-ID: <20191123174925.30b73917@cakuba.netronome.com>
In-Reply-To: <1574451706-19058-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1574451706-19058-1-git-send-email-tlfalcon@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 13:41:42 -0600, Thomas Falcon wrote:
> This patch series fixes some shortcomings with the current
> VNIC device command implementation. The first patch fixes
> the initialization of driver completion structures used
> for device commands. Additionally, all waits for device
> commands are bounded with a timeout in the event that the
> device does not respond or becomes inoperable. Finally,
> serialize queries to retain the integrity of device return
> codes.

I have minor comments on two patches, but also I think it's
a little late in the release cycle for putting this in net.

Could you target net-next and repost ASAP so it still makes 
it into 5.5?

Thanks.
