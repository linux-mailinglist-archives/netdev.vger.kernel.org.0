Return-Path: <netdev+bounces-4120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E3270AF38
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 19:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E6BA280E13
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1162C6FDB;
	Sun, 21 May 2023 17:14:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E146AB5
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 17:14:33 +0000 (UTC)
Received: from fgw21-7.mail.saunalahti.fi (fgw21-7.mail.saunalahti.fi [62.142.5.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01679E43
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 10:14:26 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTP
	id ee8f2be1-f7fa-11ed-abf4-005056bdd08f;
	Sun, 21 May 2023 20:14:24 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Sun, 21 May 2023 20:14:23 +0300
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Wolfram Sang <wsa@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>,
	Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-iio@vger.kernel.org, netdev@vger.kernel.org,
	openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH v5 2/8] iio: mb1232: relax return value check for IRQ get
Message-ID: <ZGpRb65GcaMRagiq@surfacebook>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
 <05636b651b9a3b13aa3a3b7d3faa00f2a8de6bca.1684493615.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05636b651b9a3b13aa3a3b7d3faa00f2a8de6bca.1684493615.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 19, 2023 at 02:01:23PM +0300, Matti Vaittinen kirjoitti:
> fwnode_irq_get() was changed to not return 0 anymore.
> 
> Drop check for return value 0.
> 
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>

With or without below being addressed,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> ---
> Revsion history:
> v4 => v5:
>  - drop unnecessary data->irqnr = -1 assignment
> 
> The first patch of the series changes the fwnode_irq_get() so this depends
> on the first patch of the series and should not be applied alone.
> ---
>  drivers/iio/proximity/mb1232.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iio/proximity/mb1232.c b/drivers/iio/proximity/mb1232.c
> index e70cac8240af..3ae226297a00 100644
> --- a/drivers/iio/proximity/mb1232.c
> +++ b/drivers/iio/proximity/mb1232.c
> @@ -76,7 +76,7 @@ static s16 mb1232_read_distance(struct mb1232_data *data)
>  		goto error_unlock;
>  	}
>  
> -	if (data->irqnr >= 0) {
> +	if (data->irqnr > 0) {
>  		/* it cannot take more than 100 ms */
>  		ret = wait_for_completion_killable_timeout(&data->ranging,
>  									HZ/10);
> @@ -212,10 +212,7 @@ static int mb1232_probe(struct i2c_client *client)
>  	init_completion(&data->ranging);
>  
>  	data->irqnr = fwnode_irq_get(dev_fwnode(&client->dev), 0);
> -	if (data->irqnr <= 0) {
> -		/* usage of interrupt is optional */

Maybe this comment can be kept.

> -		data->irqnr = -1;
> -	} else {
> +	if (data->irqnr > 0) {
>  		ret = devm_request_irq(dev, data->irqnr, mb1232_handle_irq,
>  				IRQF_TRIGGER_FALLING, id->name, indio_dev);
>  		if (ret < 0) {

-- 
With Best Regards,
Andy Shevchenko



