Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7867B1BA683
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgD0OfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727059AbgD0OfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:35:05 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2256EC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:35:05 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id w4so19007378ioc.6
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RK0hSPruGH5wgdaq/HDotDEGz6RjTTyx2lw9fasoMpo=;
        b=QDFfTGaqy3zhpi1tupg701lr284YRoemoZOIloZOCYvR7hSgHmYsqVu4gZtiSn02A4
         3gzRveuyLt1BEfv7BYSn7JpoiYbg+kO4EQ+OBqMrcKRZ1dp+gHaOt/sTP371kocS9h8F
         vmRkKWwKnp7EtRGvEMbRzB2ocxE/t2WF+2pz6xdG60BOdupvmE3qm3PB7wZgFbl9G9gr
         7GUsEgp/r6Vz45k1kJy8qZSBg9V/oqUF3+BMVbxsoG1CX1Yg76Z1abAjUtpTqvqi/5Q7
         sPoNIB0UqhJpmsqOqsB0OIwhr0rXaoD2adkHQBH8Fr/lCzvbmtawSllopdNIZUCW+tm/
         gClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RK0hSPruGH5wgdaq/HDotDEGz6RjTTyx2lw9fasoMpo=;
        b=l8tb7HdAm3XKEY2h+Kz//APPl+AevE+Ynga27AIbdJVCPmLQo7NVmZpK99FBMzMGph
         YVfKKdzxPCPZEOyQBewRhYorOg0zrYPWQzCMt0n0znnR7JywoVZuhZ6G3nIKt9J+rPzR
         CffMu+HSDpyDctXaeTMGc7CdmfAH6gZ3YGkb8OsudicSUFYGmpjkMKF/n6n/mHaWjflb
         NISlv1BxewF7mJUOHB87KpKlEmTKRY6ht2R9wf2qc7D442sXobwMWSYDXCwpDX9YOz2M
         z56to6JOgw/YBvfowLfg6Kf9poF3M9U1nG27pdChFmbglp/4GLUVR+BxngF5XqwI0VDK
         IPkg==
X-Gm-Message-State: AGi0PuYKqvA4TUAfXTkSe0nJbk8P69P0pdciceYaTamkZtDuciwy5b8k
        jXs+d0RSw+a4zY4OBlm574+PRX8c
X-Google-Smtp-Source: APiQypKiSZpzw5cPNuACqp94dLasb+cTnD90HUTKlWZmmMiU+5SUSJCpvQiu55Psff0Zffhszxil8A==
X-Received: by 2002:a6b:b8d6:: with SMTP id i205mr21907561iof.123.1587998104285;
        Mon, 27 Apr 2020 07:35:04 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id k3sm5544685ilf.67.2020.04.27.07.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 07:35:03 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/4] iproute: mptcp support
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     dcaratti@redhat.com, stephen@networkplumber.org,
        netdev@vger.kernel.org
References: <cover.1587572928.git.pabeni@redhat.com>
 <e6c0df38518ecc2b213bc140dc74fa89188f84e5.camel@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4389dc2d-f392-2ec3-7696-cadd05652963@gmail.com>
Date:   Mon, 27 Apr 2020 08:35:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e6c0df38518ecc2b213bc140dc74fa89188f84e5.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 8:04 AM, Paolo Abeni wrote:
> Due to PEBKAC, I did not include your email address in the recipient
> list. Do you prefer I'll re-submit this including you, or are you still
> fine with it?

Generically, sending to me directly makes me aware of patches in a
timely manner. Sending only to netdev means I get to it as time arises
to scan emails to that list.

In this case, I saw them over the weekend. Just need time for an
in-depth look at the change.
