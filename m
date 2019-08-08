Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D2386147
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 13:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbfHHL7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 07:59:13 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42848 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfHHL7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 07:59:13 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so117442382otn.9
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 04:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b6JrIQE5Up2PWl1lwg59hcX9CPUH6HQlxlPQeaPRWBg=;
        b=XbYWUbtAJwn790VDlIkugw2w5QJJyivrS2cDzJNTozEn5S/biqrDEvKRFJxNNopYZU
         GPfGvdy437SJ2hRUlEAO5T3o+bNk16APrKsOxGXdRUCZd1LRCZ5W/TlCscJYhMKEb3L7
         keu3VrItN2Yz3/NRiUAHt+XOfSqxgTPUYJA/pQ8ehX2GrnSbe3/URKAU+XcqxCHO0Z65
         E5c4OE6ceF8YgXYyTBjLNK11Tl5h4rgbz1SnITJnHzda8yBvR9Ymxhsq/nM/Xng0lveJ
         ve9xcxZvfqcJR8kFVDsvJNLksqF8SkE73099xoAnTpQvckgTM6Cm6hJsI6qpTX5gB5Oe
         TFYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b6JrIQE5Up2PWl1lwg59hcX9CPUH6HQlxlPQeaPRWBg=;
        b=dPujoqen1vCLv2OaPlCKYVDC3EgEqH46ZR4v+F+tK6UqHopRuzHoRA9SycnuLq3ArD
         oKL8tXWQ96QfmhlSF6dWEbDZtUMsfOpgTdUO3gxDBiCeHjsgBu+Zd3jbyO9O6jy2wpHu
         iALA/QwF6L5X7sJfVSBK5MwrMas1WTza7sPwEIQqGv6ggkwH5oRwLwgR8so5BfnTpjOP
         /GdjNhw6bX5dsa/D32ckyfT5pAlShHwSxilblAcMGgLpEJiUA42AaPus33XtHEE1ER5t
         4jTj/PFMO0QxOzNb0KP34VJwvltGgtHM28n75JjFGZI9fwxzSmJjCpBmQaMvrMEA4/oL
         cQ1w==
X-Gm-Message-State: APjAAAX5JCgzPPm3r98PxWrmHHAO+X4FeXU3AEc4uw5yNGaMX2C6I5Zn
        VJMrTsl1oMmdcYoDJd0L27Z5Jv+yGck0QPcxrY0Xhw==
X-Google-Smtp-Source: APXvYqzdXNWP6XOcflrQFtWs/KcmMwL+PcFBDcdOOTjeRS5KqUxHgM7FIPeSfNSwYp9Acdjzv+J/YFXlvyxPui+rIJs=
X-Received: by 2002:a9d:27e2:: with SMTP id c89mr12945485otb.302.1565265551923;
 Thu, 08 Aug 2019 04:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <1565221950-1376-1-git-send-email-johunt@akamai.com>
 <1565221950-1376-2-git-send-email-johunt@akamai.com> <c1c2febd-742d-4e13-af9f-a7d7ec936ed9@gmail.com>
In-Reply-To: <c1c2febd-742d-4e13-af9f-a7d7ec936ed9@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 8 Aug 2019 07:58:54 -0400
Message-ID: <CADVnQym6Ggo=16NBAAsxDVSdfQxctDzetvE6g7nQqcn6H5hV2g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] tcp: Update TCP_BASE_MSS comment
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Josh Hunt <johunt@akamai.com>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 2:13 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 8/8/19 1:52 AM, Josh Hunt wrote:
> > TCP_BASE_MSS is used as the default initial MSS value when MTU probing is
> > enabled. Update the comment to reflect this.
> >
> > Suggested-by: Neal Cardwell <ncardwell@google.com>
> > Signed-off-by: Josh Hunt <johunt@akamai.com>
> > ---
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Josh!

neal
