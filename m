Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E42915ACDD
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfF2S2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:28:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45933 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbfF2S2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:28:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id z19so4031658pgl.12
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 11:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2piljkFTrMnGQ9xHc4HcFCfz/GqufVDjlsOJBGGwAjE=;
        b=VsBEjCa6wqVABm/8BbZ+Jfy+OxIrNomBgcJjZEQ8LGL2EbQhAhjMdhYbAkaNpdq+P2
         ALJDq3jKz0vTIoxwpAtkNyx7aFeZWVJexdSIoMjS8vIQI4d+YzZpd6tl5PNLwn01MXaE
         T/gToyyEQtH3AS0ftsw9GyEZ3nGZJEFFsSdEZRHCMuR6QmEO/0CMPKGPyO2y32KxdqSz
         d4FuB3ARktF+nOZa36IXkoin0gRORb2OJlCzTafm4mrgNpQ79LQ8OXf6CVHutUFcnyOX
         1nzyUm+tggWo26DIvNY668GxwFXHx+pvTx7xYKRKEbsvYwsM5szkk8tkuf5mO3g+nunD
         fmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2piljkFTrMnGQ9xHc4HcFCfz/GqufVDjlsOJBGGwAjE=;
        b=KX/zxKUv+csFdrBTTHyAAC16K6uqA12h7/teaIU31WlaSpgkRcgAHGJr1yNBKj+cmP
         s4hxW5VGO6/08koQ3UQpXrcE1sQYAhnZbKsrJygD3Q+bOOLYCxlv2hAnlEcYgG7/v7hg
         4/+0B0vdjckKbvPBC2ohasJNY/F7ttZD3cDLn1FP1M6HVscBttyQ1KT6a4LZxYFeCUXh
         s94chJrKornfRgJibyRUklGczc1vtz0OwOBV0XY3vQiPp8NdLARSaJkPa+F2CbuxdAB8
         JXRD/6WmOX+drfu8PR6tYNLhkws3CURfPHhKnECnba7gDJq197UGu4tNbp25hhwC7YRJ
         klQw==
X-Gm-Message-State: APjAAAVwF/MLBXoenVjLnwpILXwNACyzWrvVkoWAB5p63FlP/IKXsqMk
        AFMxtsglmD/Z+xyuPLl0+QC1Rh9FPUg=
X-Google-Smtp-Source: APXvYqwBhZEo15zczc5QxZ582fQ80oAGGEpoXbkBQvdDzeKxwMDFV4LlkdRMVUYaDp+67edLHWjH9Q==
X-Received: by 2002:a17:90a:3401:: with SMTP id o1mr20634075pjb.7.1561832911605;
        Sat, 29 Jun 2019 11:28:31 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id o14sm15422801pfh.153.2019.06.29.11.28.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 11:28:31 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:28:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/4] Add gve driver
Message-ID: <20190629112829.698d2d8b@cakuba.netronome.com>
In-Reply-To: <20190628230733.54169-1-csully@google.com>
References: <20190628230733.54169-1-csully@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 16:07:29 -0700, Catherine Sullivan wrote:
> This patch series adds the gve driver which will support the
> Compute Engine Virtual NIC that will be available in the future.

Looks like buildbot also found a bunch of bad endian casts.
Please make sure the driver builds with no warnings with W=1 C=1.
