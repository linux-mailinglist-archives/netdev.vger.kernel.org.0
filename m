Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26FF226FBE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 22:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgGTUcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 16:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgGTUcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 16:32:05 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ED7C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 13:32:05 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e8so10863075pgc.5
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 13:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sF9miVRFWvVMYbYKNnVDxFXtkHgLD8hzC7nr7kyh7Xg=;
        b=ACnT+E2c8FZz3TisoU8EuWYvq/ivqN+hGzRh+6I77KYGa7dafJAg5RbfQu/wl8rAg7
         5BsX+SUmlGQzT/QxegFhSAJyflQEFPSV8kIc+UxFMTA76E5OgiebQ0B9Xqdx6COkt+3y
         0QAjZ2802aXu40xYUOoRvDc7G9YifJRpk+itSOqauoDX20UFYQ0TBwowa7eGyWtnW9u/
         PLx85ue9zM9dcAa8TW6akY6Iz7ykbXhGqcp7cbc7qsvpVq8FaPGM5smMVANmjJ1DWsva
         ZIVtqe6UorbiIcyl5Ha4kimqQhZpeoxgwP9yihxA4g84nJNLNDdGgiDpjHEiK1cvfKEi
         Ge4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sF9miVRFWvVMYbYKNnVDxFXtkHgLD8hzC7nr7kyh7Xg=;
        b=WSVKU0z6AWvnP9syLOUaZxQVT0zM74oUd/TdHxVnUrFU5uoDtHiwz5JPEeFPYanFL4
         TXX0FtcphqmoKHa1z5CwXfPuNsRVhC/hZ9DmjjUqBIHOeA9MY5ideh1BF3GUiA0Ts2YP
         qnECu33pXQDWqZW97zmhriWtQRGUiImDnVvMh1GcEwDHDOJvR8dxMUQF5DH8XGTaE46a
         LzhpaeNjdUrbHvVCUEduVBoW6QP22KjJiZYH04ZHIsT7KIWbhelasf4dPGifCUTJFzMR
         8ngQPhzbK/9Qz63sD0R1cufORcH7PNIZB8u3H5CBbnhfSmiie0YgAfXGiw+C+fSEk9qK
         /UGg==
X-Gm-Message-State: AOAM533VrRRTmL7GEdOJ57Y1qQEYxsKtnPG68KTdIyC+Fg9BX1QOu3yO
        1SEERzrZKWAm6h95I3DjBK23x740W2YiXQ==
X-Google-Smtp-Source: ABdhPJzAgKagZgTKms7r5UgTQg/rT6h+LOPt4Vl0BefeTvY7wVghEXboFSc/vzWsPGh2FexGM65ezg==
X-Received: by 2002:a63:9dc4:: with SMTP id i187mr10301396pgd.126.1595277124628;
        Mon, 20 Jul 2020 13:32:04 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b18sm460848pju.10.2020.07.20.13.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 13:32:04 -0700 (PDT)
Date:   Mon, 20 Jul 2020 13:32:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martinvarghesenokia@gmail.com>
Subject: Re: [PATCH iproute2] testsuite: Add tests for bareudp tunnels
Message-ID: <20200720133201.19eccdce@hermes.lan>
In-Reply-To: <2e407fe6bd0983d7c9d98793273b839f2afe7811.1594996695.git.gnault@redhat.com>
References: <2e407fe6bd0983d7c9d98793273b839f2afe7811.1594996695.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 16:39:46 +0200
Guillaume Nault <gnault@redhat.com> wrote:

> Test the plain MPLS (unicast and multicast) and IP (v4 and v6) modes.
> Also test the multiproto option for MPLS and for IP.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks
