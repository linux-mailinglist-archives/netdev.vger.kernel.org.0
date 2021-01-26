Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0863048D9
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388132AbhAZFj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732114AbhAZDYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 22:24:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7B822583;
        Tue, 26 Jan 2021 03:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611631419;
        bh=WxM0D+6iES5SFbyYQlBl/+BIf+WzcsCilaXdZAepgF4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f5m+J9f8ltXFn58fzGIU1pyAwPbvN0GmMzWfA9IgJrDlnTq7VWGlRfHs4kjHnCpzv
         HkveqGAzBXoLVhxT9i2ztTH2rrCCDmIWuu5r3pjKfCMufmNJk0P9YmBRZb8Fmyh0/6
         lGogzBprVgI2a6luv+pgFbddKy4hhaSduOiDWLkhj1bGMxJ6+ipoSw0nwrtTQI5H+4
         n87k8xBWwrnswUoB+VrCgADR0zKy3qOs1j0H4w15sG2WPJVz+v6/E0wFsu5UT6bmvf
         vV2qisaimvHwKjzhMAs20BA3P1Mh3QpL3lHVw0kzy67Hzmvv7dDisS1kMTjbxcIUfz
         yP1YfIL5kJbkQ==
Date:   Mon, 25 Jan 2021 19:23:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        gospo@broadcom.com
Subject: Re: [PATCH net-next 00/15] bnxt_en: Error recovery improvements.
Message-ID: <20210125192338.526932e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF=yD-KFe+QAb5JkK1xYUTzjgL32cOWUEqsX3qJrbg3ky-ZPrQ@mail.gmail.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
        <CAF=yD-KFe+QAb5JkK1xYUTzjgL32cOWUEqsX3qJrbg3ky-ZPrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 20:37:52 -0500 Willem de Bruijn wrote:
> On Mon, Jan 25, 2021 at 3:36 AM Michael Chan <michael.chan@broadcom.com> wrote:
> > This series contains a number of improvements in the area of error
> > recovery.  Most error recovery scenarios are tightly coordinated with
> > the firmware.  A number of patches add retry logic to establish
> > connection with the firmware if there are indications that the
> > firmware is still alive and will likely transition back to the
> > normal state.  Some patches speed up the recovery process and make
> > it more reliable.  There are some cleanup patches as well.
>
> Acked-by: Willem de Bruijn <willemb@google.com>

Thanks! 

Applied.
