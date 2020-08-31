Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCDD257E37
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgHaQIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727919AbgHaQH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:07:58 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AD3C061573;
        Mon, 31 Aug 2020 09:07:57 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h10so6517411ioq.6;
        Mon, 31 Aug 2020 09:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cpTeiy951H1J8keuU2TPT0HxhztiRJ+NC034zr87MJ0=;
        b=YX0Ys+U33yLhe/BNdT3Rbv/PKiYH6Iwn1VIJdPLknXBwgV9MkG1y+h9HkTE2BfAcjA
         3cCTgC9Q7H4FM/gqWcmP59H/wPg510iU3WKIuumQlsD9QTOt1oXobx4Ab4QPNqgF7IXb
         iIQIqyn8HNUuESv0vuw4O+fZsdVxmnv9xCfsPkODKIingDf0K1wkJKgjobgZvom1UkmW
         A4f4AMNsSo7pfji3IGEPnSjATQC/HXLNBwPw+tI8oaC7yQuor/VUntZpdaSJuzyHLTNt
         1LFBU2XqI7tBvsLtmINrP0QPsQzBXWfYouOTIwo6wco4kMTX2Coox/ti2AorcSSd7oc1
         QX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cpTeiy951H1J8keuU2TPT0HxhztiRJ+NC034zr87MJ0=;
        b=LGVXcv5o/s/kY/2RNRra4d53Ga9gglbXlK0wTSm/EN50Akm6Z1WrHp6/NPXYIH+55P
         wa9lGw0hky0ldWRrvBkV6QmJsmrf6ygX55Y6XpxkJwE/m8boT29yvDAUm1tNGuPMmwuU
         bwyp1BarmCesX/++xpnSd7AZOd4zl1a4rA8oA7fqgKUR6LlqU6QzBnq/LqQFFcjDF3Vn
         IS03iTV/0cuLfc3t5wkKdX1GUEqnt8gTV+W07k9hQlvkWbQIWUMAjKhv21/6Wr5m2MNI
         B002Rri79oDv8oYm0PGazR09GeHuwDM5cPfCSSosYiS11U0HykUvFIxJJAj/cvsyhWih
         54dA==
X-Gm-Message-State: AOAM532b4H9Y0D1q2KSWT5HvoNdxuw9UbmBu3zp0UN7korNkLM9BSf1g
        HBlQjUbIR2f0ssR6PoFJiA4=
X-Google-Smtp-Source: ABdhPJygjApmzPGlErVFoGThvUoSfg3YyLVRZx4WrNlrDKiUjBeyBy5Be1a8rarVe++d0CG62f3yGw==
X-Received: by 2002:a02:1c0a:: with SMTP id c10mr1894416jac.75.1598890077223;
        Mon, 31 Aug 2020 09:07:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4b7:afc3:c2f:5c18])
        by smtp.googlemail.com with ESMTPSA id q17sm4773954ilt.10.2020.08.31.09.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 09:07:56 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpf: change bq_enqueue() return type from int to
 void
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org, toke@redhat.com,
        brouer@redhat.com
References: <20200831150730.35530-1-bjorn.topel@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8eda320b-3e32-d0c2-7746-cdef52b2468e@gmail.com>
Date:   Mon, 31 Aug 2020 10:07:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831150730.35530-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 9:07 AM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The bq_enqueue() functions for {DEV, CPU}MAP always return
> zero. Changing the return type from int to void makes the code easier
> to follow.
> 

You can expand that to a few other calls in this code path - both
bq_flush_to_queue and bq_xmit_all always return 0 as well.

