Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82AA8A42BE
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 08:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfHaGPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 02:15:00 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39335 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfHaGPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 02:15:00 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so4593277pgi.6
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 23:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=efcP+2uSp4jtnMwhqWsmh+7skZz3J/Gs43rRUZHxuik=;
        b=RZQYtBU5aKc97UAlw7Qk8lSuCvcyxwLFmk8DjUUMKSz0OCKILXfkZCAz0UHPspvb7k
         6b5m9dJYgBQZ9ODA+hfR/tMtD7nj44BGh/hw3k8DOBBqjo7FGvxvSGW7xHgurGHntSFc
         IMa41m8PoThNe3HewwmUKoAX7AloayezD0z7sykBCjgWuer25CcPp8Hh2I2nT0PE2MBh
         M9wBGputYk7zq/cpOADfCCfFeSw/vfvpYFpdE3ORjoF9tkcbr36BZRnZ2mNhGGsSPOB9
         XFuE6ulcap1ww2MIEbkBl6cM2bU1mOm+uahEJHrkonpQsQ4DPlXO1K3nnJOFBNa9FoVK
         w6FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=efcP+2uSp4jtnMwhqWsmh+7skZz3J/Gs43rRUZHxuik=;
        b=GMPuwEwSnPt0Wn800uyeWRLkeDTHGjLbkUrDJDLFmNwa5loyRXXKBpqEsvVCPrv1eV
         KPwMRKH3lCFvA7LNdbclizaPw7kcc2uEwXpz1zsqZe7R8CgGXpebdV7hHPH05bGvpl2s
         XgMYZ1gX5JVaMc6HtxU37q+u6E/foNwCBDwdsPhvhU+T/J3Og/V9x+vaqThKo+vwd9qv
         4MJbaV9hneDEG/t/+zR2+MpUBaTFKQAr88HFiP3Az5DfAtvg9bzw7Nd+SwNwaNYHf1o6
         g6nS50xyYc5dvdlEW4QFDDq6Odw4BxwB7nkjHgT2in3AzXP/0v1BEedc9riq0t+BAINi
         y7Ow==
X-Gm-Message-State: APjAAAXdd02FxF+kRivEY9YdzBxNndA1SagYkDpvG7a4j/5hcfuIYTCo
        JTLyG4LFzotYAdT2u2PIlQw6kJFOhbc=
X-Google-Smtp-Source: APXvYqxfvT1+fVy45kYsdeFDN9uYg6tskta18VC6MJlIw7PlNVIgu5dibTgcWTf4GI7Nw5CVns3fWQ==
X-Received: by 2002:a17:90a:2182:: with SMTP id q2mr2465950pjc.56.1567232099654;
        Fri, 30 Aug 2019 23:14:59 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id o3sm22454943pje.1.2019.08.30.23.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 23:14:59 -0700 (PDT)
Date:   Fri, 30 Aug 2019 23:14:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com
Subject: Re: [PATCH net-next 0/2] Minor cleanup in devlink
Message-ID: <20190830231436.34f221b2@cakuba.netronome.com>
In-Reply-To: <20190830103945.18097-1-parav@mellanox.com>
References: <20190830103945.18097-1-parav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 05:39:43 -0500, Parav Pandit wrote:
> Two minor cleanup in devlink.
> 
> Patch-1 Explicitly defines devlink port index as unsigned int
> Patch-2 Uses switch-case to handle different port flavours attributes

Always nice to see one's comment addressed, even if it takes a while :)

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
