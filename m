Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF52E1E4520
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgE0ODu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730322AbgE0ODt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 10:03:49 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69BCC08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:03:48 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x12so19172713qts.9
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=skmSWybnBTCGokpwv9jvWq+e2RdEJic2AGjFMT4QZLY=;
        b=Ol46H4MeKsOdqOrSNlImCnrrEBz9Gj8ewGLtxnUyeXtFkkw4syiXhP2XUwGdeyiTaN
         IQQJZeL+kU4j53c4JAyjdUM61/g+oqU+D/NdUSAy0U/QascrXYB0mewA060AfIfbxtTe
         jGZehGZtq9K1CZExwLiMwDNGl+qnqNcL79UOJuFGzMjONoHAnJbhfYXf22aoXlqncvqa
         uyfCE+lndvILH32eawdSBjjFumB4g5sXNrQQfVdiz8Yn/QYxwssQGU+DxeJnrwtpbkdM
         Ikb15o3OBj68T80xVenBgy7WLdbX7dbrXl7pB/0HgTY8tG/yoY8mhrwiStERMptAJ1iX
         ZN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=skmSWybnBTCGokpwv9jvWq+e2RdEJic2AGjFMT4QZLY=;
        b=dfETyqaRMAy8la08ohHaPEMI2EwWc5inEI6Hu99UiAy1JcEVH0WtM5bWNJoqCjK6aL
         P/u2052iHXrEQXEN2fRaraAbd4KmhieoNKuSAyC/jnMUDVkb/OnatcXYDCSGSh8O+dtC
         mcu9qKQXkeoagqxGaOmAlq6a4b+2vGY7DWPk1Vz10p3hH347cCuJI46nXwiHZQMYbCTt
         F9cpdqs3PKnSVuhvriFP8ESE/VjWn/DaMh0hwsq4Xy7NfdwulP2OvV6K+PxE6eCpLuy/
         Flaalp5ICFjGF+XiZvPpcAP8jQfIjdzbmCVQZiPaBWXWHmF4r5nK591sQz5Irmnf4gBn
         xK4g==
X-Gm-Message-State: AOAM530bOuItTQd6HkelbWR8Mh5WqQMvuUDm7tJ217UKTET3cEgRmnpG
        Nc2OXjyOFVpUjcOXfqWZgkM=
X-Google-Smtp-Source: ABdhPJwOJq/rbhrjgItUZwT5toJk8J0WJCniovA9j2kAgHfuke19zFxlahaxlCv+UEVDPdTWWH/P5A==
X-Received: by 2002:ac8:2c28:: with SMTP id d37mr4415549qta.68.1590588227450;
        Wed, 27 May 2020 07:03:47 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id p17sm2247988qkg.78.2020.05.27.07.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 07:03:46 -0700 (PDT)
Subject: Re: [PATCH bpf-next 4/5] bpftool: Add SEC name for xdp programs
 attached to device map
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200527010905.48135-1-dsahern@kernel.org>
 <20200527010905.48135-5-dsahern@kernel.org> <87367l3dcd.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <18823a44-09ba-0b45-2ce3-f34c08c6ea5f@gmail.com>
Date:   Wed, 27 May 2020 08:03:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87367l3dcd.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 4:02 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@kernel.org> writes:
> 
>> Support SEC("xdp_dm*") as a short cut for loading the program with
>> type BPF_PROG_TYPE_XDP and expected attach type BPF_XDP_DEVMAP.
> 
> You're not using this in the selftest; shouldn't you be? Also, the
> prefix should be libbpf: not bpftool:, no?
> 

The selftest is exercising kernel APIs - what is allowed and what is not.

Yes, the subject should be libbpf.
