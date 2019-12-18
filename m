Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A41124FC5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 18:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfLRRxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 12:53:44 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52537 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfLRRxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 12:53:43 -0500
Received: by mail-pj1-f65.google.com with SMTP id w23so1214760pjd.2
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 09:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Oik0EX3Aqw3caiUjtSTJsDT0wCPAO4IzgU6Jm9GlGbE=;
        b=ldVh2IxVBvguky0dNxxII6zQJUCGZQ25N7135UYWYkLg1fZmshTiFgDBi9Ne1X9SNH
         crbnB2RHwe80ReCYfjBNXvELQ6euMi8IIVFZHTAK7SrS/jr+QByvj4GCscg3hyaaNa+G
         v6YMfQ1EcsuMaLRIEjXzGJHW032VSRQyNr9RXZgZRsjT2iq864mqRSrs1Xj1A484EMS4
         Zwrd0YXTLzxgMTFvT2rw2phdjSy7tcHDsepDOGGtmD/hjPnT7y+9WEM06nXDfh6M2v+3
         K4lqdVDgYJrNdheCweh+n/eFts6dX2jQozH4yTiLhoNwx0NFrnKcmjW6gHCPD64Kga2m
         6PLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Oik0EX3Aqw3caiUjtSTJsDT0wCPAO4IzgU6Jm9GlGbE=;
        b=qJgsleguIx7yiJ0vow/ZLaGsq+7eD3QeUrFyOPnx92gSjjQmBNpnf5wCkbFbCh2+XV
         W1HQYXu5ckA8WJ5//buOdghu2tpgMgNeVIp+GqUqXYzb3HDhA3ACCjFWuoDxQQs79cBC
         w8fKCUfN8f5aMf740pk5Pozxxoe1fpGzRQfcvvvkJzxHBwIn4m+ZHCHZyH96RGLDpOi2
         QWQPsBkSOTRWLw/elemsNwMDC5G+GRnubpA7uPfBzicjsQbnheLPWylLLoIkn1sEY8h0
         eFtKXCtPlYyvGxv6HDxsHiqHWsJ+rHBHNnjXl9JjHVUP9dQgxt7fGo7J144xEbFJDjbf
         1rxw==
X-Gm-Message-State: APjAAAXVxqQ/TkRq+8WpB8UGBTht8XaXMjw25fiTXRr8YMO6s1z0081V
        J3+QA0FnXf5/nWuhV5+/roYq0g==
X-Google-Smtp-Source: APXvYqz4UbkjLS2z85PDVYB05YvZzVsUQElzcrPuN8R2CvxQ/yIdke4rJeVo2iHz5Oqe/SJ/n1rYWw==
X-Received: by 2002:a17:902:968f:: with SMTP id n15mr4224537plp.12.1576691622895;
        Wed, 18 Dec 2019 09:53:42 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::5])
        by smtp.gmail.com with ESMTPSA id f43sm2676764pje.23.2019.12.18.09.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:53:42 -0800 (PST)
Date:   Wed, 18 Dec 2019 09:53:40 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] sch_cake: drop unused variable
 tin_quantum_prio
Message-ID: <20191218095340.7a26e391@cakuba.netronome.com>
In-Reply-To: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
References: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 14:05:13 +0000, Kevin 'ldir' Darbyshire-Bryant
wrote:
> Turns out tin_quantum_prio isn't used anymore and is a leftover from a
> previous implementation of diffserv tins.  Since the variable isn't used
> in any calculations it can be eliminated.
> 
> Drop variable and places where it was set.  Rename remaining variable
> and consolidate naming of intermediate variables that set it.
> 
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Checkpatch sayeth:

WARNING: Missing Signed-off-by: line by nominal patch author 'Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>'

total: 0 errors, 1 warnings, 0 checks, 125 lines checked
