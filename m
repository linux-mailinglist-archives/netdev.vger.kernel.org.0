Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F91DD13F
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506175AbfJRVep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:34:45 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:34136 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506134AbfJRVeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 17:34:44 -0400
Received: by mail-lj1-f172.google.com with SMTP id j19so7627685lja.1
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 14:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fsGrteaC6evCzoR8Irlqj7ZXyGCYWbdFDZ6CBVhVrwc=;
        b=QzIVKML+xhkD04dfhorhLgu9QpVfbvm47zSB86GN1H1uHnAWuDe2Diu8NXK+MgwOaZ
         VkxGWJaJ9+gHJBL4MmCbANv16KreYqGkla1Def1M/C6+nOHAyfajsFr9StZQnUF0RA4o
         oEAZY+oj8FU7+dSjMeK0oDxzCyiMAbEp4u2YAZWbeJ5h8uqrUCNv214H8v8YgAoLK4fc
         rxPZC4QnU/9lZnFyACF4+RAAHZItftLnK62mryKudEc7zfz+QdyTTyRtYiJxVfVW28Y5
         u1bk5GWl70CwVnT6jUCm2ozNEurnBhrUxGed+Kk86HSo7o9Id7bNIMgAATcHJSRw3g0O
         1cYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fsGrteaC6evCzoR8Irlqj7ZXyGCYWbdFDZ6CBVhVrwc=;
        b=OfC06stYJGae3f2FCMcQAT6zLVb/e2JjasFXV+n5di0AJCt30Fp+xzemywANTYiZJw
         QhLfKTkzWkZZNULoHNbE3Ev2gVQzruuI9OZHES8ld4pcUbiW7R9GyC0ENdDcsuJSCjvy
         ctg2aKDj29UhopttmHrXqqGkt4B2eYMXb55n5Z0xhXE6TjdVUUiipI54O9OyU1+s125+
         0sw5L9iryLQyO0P/xGWALNnZbpHfYKU+CJQnnM4/Jnwj/q6jLnJ4icDtHVQC/IgvaoCl
         21ncynd78svIjr8v1VRSll+iFTZMTx5qqJbT1gIKNUN7tPQ65Sg2RAmntMVCZxVsJVD+
         8pwA==
X-Gm-Message-State: APjAAAVjcXBfeu6qT13XfQDpULt3E0jsXNviki/itEM+4RpaLz8hufCV
        m9bkmN6VS9cADUxcToNCAO1/VA==
X-Google-Smtp-Source: APXvYqzXcF3JsTpoU9CqK1ruekci9gU6kZB2RdSbwFhEPttnPXa5Mhas/SuYXRm6/+L2b9M5iQCCQQ==
X-Received: by 2002:a2e:8654:: with SMTP id i20mr7671292ljj.238.1571434481520;
        Fri, 18 Oct 2019 14:34:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q21sm2709850lfc.2.2019.10.18.14.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 14:34:41 -0700 (PDT)
Date:   Fri, 18 Oct 2019 14:34:33 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018143433.3d45ef0b@cakuba.netronome.com>
In-Reply-To: <20191018202748.GL4780@lunn.ch>
References: <20191018160726.18901-1-jiri@resnulli.us>
        <20191018174304.GE24810@lunn.ch>
        <20191018200822.GI2185@nanopsycho>
        <20191018202748.GL4780@lunn.ch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 22:27:48 +0200, Andrew Lunn wrote:
> I don't really like the all lower case restriction. It makes it hard
> to be consistent. All Marvell Docs refer to the Address Translation
> Unit as ATU. I don't think there is any reference to atu. I would
> prefer to be consistent with the documentation and use ATU. But that
> is against your arbitrary rules.

So is MTU yet all command line params we take as input or output use
lower case.

I'm with Jiri.
