Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085B23730F0
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhEDTkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbhEDTkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:40:18 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA40EC061574;
        Tue,  4 May 2021 12:39:21 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l2so10640387wrm.9;
        Tue, 04 May 2021 12:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GDyWX0q7nbyvuzEr5U4jc0HN+67Caz0FfP8gT+cK9CI=;
        b=aXymTqrJX5ndGEh0jKK+icbf6rvTAkZPknIFPTjoPU+LsKPY8wmIKr47uiQnvw6UQV
         jXairnmn44SEEtETHV/uZnWM9Dl3l6n+ePHgNKiBrppVAESTIYpze3ntxzhxvRGIGm+F
         u6p0Lu9BTl2jbtXZFrD5r8SeM/eR1YK18voshYYsE6jSkXEhQK3X0tGsOnVb0/LaFnAD
         xD4N+w0cZQTpW3NePqfbuQdo1KZKZb02upMjK5GvHyqMlRMZkmLeHkQQbCo30PVRJhSh
         BPjaaXct+fz0P6hvbok9UM5ehZ0bjnItABBzjLTyH9Lz6i+sv2EjHKDJPpZZjOh+bDpv
         fzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GDyWX0q7nbyvuzEr5U4jc0HN+67Caz0FfP8gT+cK9CI=;
        b=Crdj/vgvBb/zvSMR1D/WwfwIlngApZ50Y0v7ukNOAMdh/64vOGFeLtLhIMo0mkrYz/
         PduYMLPESeB2vxZyjmMWP9BRZRz2H+fm85mYauYpPu876sbIMWcr1LMGQ/dHwSg2VapX
         LN/4ZYkGbbCadg0YgfIeue9n2zGX9R8neHi7XsGzQB0TITNwGart2X9ZiiBjjhqAB4Ri
         1JGl9ae28JPyWBSYHRhL0h3OMufLXAVh5/iHMjQOkqn9JKjMYE622wSx847f4UNN03uC
         9Bwt/MQ9c6AFH+tQHGMBu2RZJgZ2QGdwv+a4cwS7fwNqGJtLem+tfRY0fqSsaoBbTpc3
         +Fbg==
X-Gm-Message-State: AOAM531+bsg0Fr/3qJWnL4JMK7yN2YV1O30Y9LbKTt5AOdtx8q/r+ph5
        1AIkKB1tRrhFvpi4bERGBrDGAdAyc0sMuHb5fn5jRbZoRAJNgQ==
X-Google-Smtp-Source: ABdhPJzw2M+VQweZcHVDuN3fz4HlHtVDrzhc2eQ7ho9FCcN3ovlIwvTDxuYgzfaiq5WPRRTPy50crSd9zLqC72Yz7PM=
X-Received: by 2002:adf:ed43:: with SMTP id u3mr27027448wro.334.1620157160659;
 Tue, 04 May 2021 12:39:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210503.134721.2149322673805635760.davem@davemloft.net> <20210504191923.32313-1-msuchanek@suse.de>
In-Reply-To: <20210504191923.32313-1-msuchanek@suse.de>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Tue, 4 May 2021 14:39:10 -0500
Message-ID: <CAOhMmr4tYOuTVNquU5oZ=1G7vVR4mz+5q8Gb8Zy96PBioLPnUA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next resend] ibmvnic: remove default label from
 to_string switch
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 4, 2021 at 2:19 PM Michal Suchanek <msuchanek@suse.de> wrote:
>
> This way the compiler warns when a new value is added to the enum but
> not to the string translation like:
>
> drivers/net/ethernet/ibm/ibmvnic.c: In function 'adapter_state_to_string':
> drivers/net/ethernet/ibm/ibmvnic.c:832:2: warning: enumeration value 'VNIC_FOOBAR' not handled in switch [-Wswitch]
>   switch (state) {
>   ^~~~~~
> drivers/net/ethernet/ibm/ibmvnic.c: In function 'reset_reason_to_string':
> drivers/net/ethernet/ibm/ibmvnic.c:1935:2: warning: enumeration value 'VNIC_RESET_FOOBAR' not handled in switch [-Wswitch]
>   switch (reason) {
>   ^~~~~~
>
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> Acked-by: Lijun Pan <lijunp213@gmail.com>
> ---
> v2: Fix typo in commit message
> ---

Hi Michal,

Thank you for reposting the patch and including the Ack-by tag. I
think you need to wait till next Tuesday or so when net-next reopens,
then you can repost the patch.
http://vger.kernel.org/~davem/net-next.html.

Thanks,
Lijun
