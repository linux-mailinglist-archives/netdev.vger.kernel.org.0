Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894B651C9F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732110AbfFXUyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:54:33 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39768 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfFXUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:54:33 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so7581040pls.6;
        Mon, 24 Jun 2019 13:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yYbpM5tF3YxzYqVVKDq3e0vAPMgbKhrDH4c8XvHJb2E=;
        b=sUh7rzQ27VSjdy2iCAXuf7k4mvljhuXbpBCHAW5LvNykxAfqAd+t0ZSLp8MHLqCBUQ
         s6OLA3IvIxepT9kF/AkbLi1O4ijxNK1+yt2KncwhVXIFcK6Y+gGVPKKmDL7M5Vj1ArVG
         FksL3WQO+TPZ9NKkrsfAnO+3tsadAceIRkvkSp6MN+3/P0akYPOCJk5dMrwlb0v+aghr
         iWVNqpVBUEVNfgHzT9Tm67nwZeyTQX67x+c0F3V/BQ5vJJQj6KVhfVx5w0tXxZaldBK7
         eTyWnVUELc/4MlNL4RzfmKniyisb42tr+50hLxsKegcl6GoPA8IObioEe4XxUhS78wW9
         +svA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yYbpM5tF3YxzYqVVKDq3e0vAPMgbKhrDH4c8XvHJb2E=;
        b=ERTsOSvEEmNxGJwTDwYzQ2lhn6n5r7LU81BpIKicZgH3Ott25W0MkIFgQYtYOVQL6N
         HEkRlICUwtEaw/KpzTgTPzwdQdV4w374Oa4jOi+XqNXlZEeoji3KbW3bqYLGf06ivgBS
         5vWGVVPYTQfiHKykRxgIk0X0rYilaFadHenpZq+aZJZc4FUO6pQJQ0IltnwmXFL7h/AM
         Tw9QOGVne21l4tt0MlkM2kDvmuN4rVOEmIUlxT59BRsLQZo47HLJtqPRNlesAYlh+jpC
         H/RoWA8cHFvECDpitU9bkUNW3m+2JW620KlL2YiXimisYhBeq4ngga2hl/L8plWv/408
         HV/w==
X-Gm-Message-State: APjAAAVwtVc4oEAWInQkKTEAgNMsxOeltCOXK8r3UPOj47eDXun6nUzd
        127zeKeIUuN4DqsGGEC87bHInsCLq44=
X-Google-Smtp-Source: APXvYqzTs9+dtzbe0SFamAtiQxiXJx2V/x5MpBMTp9TfGMeZS1iRmETNLL3Y2lTDEYop1mU2xy7Ofw==
X-Received: by 2002:a17:902:bd94:: with SMTP id q20mr64087536pls.307.1561409673001;
        Mon, 24 Jun 2019 13:54:33 -0700 (PDT)
Received: from [172.20.181.193] ([2620:10d:c090:180::1:73aa])
        by smtp.gmail.com with ESMTPSA id f11sm12454198pga.59.2019.06.24.13.54.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 13:54:32 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] MAINTAINERS: add reviewer to maintainers entry
Date:   Mon, 24 Jun 2019 13:54:30 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <B5DAC105-8F88-43F7-9F6F-6C0B436C4F06@gmail.com>
In-Reply-To: <20190624052455.10659-1-bjorn.topel@gmail.com>
References: <20190624052455.10659-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Jun 2019, at 22:24, Björn Töpel wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
>
> Jonathan Lemon has volunteered as an official AF_XDP reviewer. Thank
> you, Jonathan!
>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
